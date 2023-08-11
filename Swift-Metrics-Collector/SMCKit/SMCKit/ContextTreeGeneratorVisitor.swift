//
//  ContextTreeGeneratorVisitor.swift
//  SMCKit
//
//  Created by Carolina Lopes on 04/04/23.
//

import SwiftSyntax

class ContextTreeGeneratorVisitor: SyntaxVisitor {

    // MARK: - Properties

    let rootContext: Context

    lazy var currentContext: Context = rootContext {
        didSet {
            guard currentContext != currentMethodContext.last else {
                return
            }

            if let methodContext = currentContext as? MethodContext {
                currentMethodContext.append(methodContext)
            } else if let typeContext = currentContext as? TypeContext {
                currentTypeContext.append(typeContext)
            } else if let extensionContext = currentContext as? TypeExtensionContext {
                currentExtensionContext = extensionContext
            }
        }
    }

    var currentCouplableContext: Couplable? {
        currentExtensionContext ?? currentTypeContext.last
    }

    // Since a method can be defined inside another method, the currentMethodContext is represented by an array that is used as a stack
    var currentMethodContext: [MethodContext] = []

    // Since a class can be defined inside another class, the currentTypeContext is represented by an array that is used as a stack
    var currentTypeContext: [TypeContext] = []

    var currentExtensionContext: TypeExtensionContext?

    // MARK: - Initializers

    init(rootContext: Context) {
        self.rootContext = rootContext
        super.init(viewMode: .sourceAccurate)
    }

    // MARK: - Methods

    func newFileContext(named identifier: String) {
        let fileContext = FileContext(parent: rootContext, identifier: identifier)
        currentContext = fileContext
    }

    // MARK: Visit overrides

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let identifier = node.identifier.text
        let firstInheritedType = firstInheritedType(for: node.inheritanceClause)

        let classContext = TypeContext(parent: currentContext, identifier: identifier, firstInheritedType: firstInheritedType, kind: .class)
        currentContext = classContext

        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        _ = currentTypeContext.popLast()
        currentContext = parentContext
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        let extensionContext = TypeExtensionContext(parent: currentContext, identifier: node.extendedType.trimmedDescription)
        currentContext = extensionContext

        return .visitChildren
    }

    override func visitPost(_ node: ExtensionDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        currentExtensionContext = nil
        currentContext = parentContext
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let identifier = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text {
            _ = VariableDeclarationContext(parent: currentContext, identifier: identifier, isStatic: isStatic(modifiers: node.modifiers), position: node.position.utf8Offset)
        }

        return .visitChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let methodContext = MethodContext(parent: currentContext,
                                          identifier: node.identifier.text,
                                          returnTypeIdentifier: node.signature.output?.returnType.trimmedDescription,
                                          isStatic: isStatic(modifiers: node.modifiers))
        currentContext = methodContext

        return .visitChildren
    }

    override func visitPost(_ node: FunctionDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        _ = currentMethodContext.popLast()
        currentContext = parentContext
    }

    override func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        guard let methodContext = currentContext as? MethodContext else {
            return .visitChildren
        }

        _ = MethodParameterContext(parent: methodContext,
                                   firstName: node.firstName?.text,
                                   secondName: node.secondName?.text,
                                   typeIdentifier:  node.type?.trimmedDescription)

        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        let methodContext = currentMethodContext.last
        let nameToken = node.name

        if node.parent?.is(FunctionCallExprSyntax.self) ?? false {
            if case let .identifier(nameIdentifier) = nameToken.tokenKind {
                methodContext?.methodCalls.insert(nameIdentifier)

                // A method call can be an initialization, so we need to add all of them as possible type couplings to be verified later
                currentCouplableContext?.possibleTypeCouplings.insert(node.trimmedDescription)
            } else if case .keyword(.`init`) = nameToken.tokenKind {
                let typeIdentifier = node.base?.trimmedDescription

                // If the method call is an initialization, try to save the type identifier
                // If that is not available, save the init keyword
                methodContext?.methodCalls.insert(typeIdentifier ?? nameToken.trimmedDescription)

                // If the method call is known to be an initialization, try to add only the type identifier as a possible type coupling
                // If that is not available, ignore it
                if let typeIdentifier {
                    currentCouplableContext?.possibleTypeCouplings.insert(typeIdentifier)
                }
            }
        }

        guard let methodContext else {
            return .visitChildren
        }

        guard let baseIdentifierExpr = node.base?.as(IdentifierExprSyntax.self) else {
            return .visitChildren
        }

        if baseIdentifierExpr.identifier.tokenKind == .keyword(.self) {
            guard case let .identifier(nameIdentifier) = nameToken.tokenKind,
                  !(node.parent?.is(FunctionCallExprSyntax.self) ?? false) else {
                return .visitChildren
            }

            _ = VariableAccessContext(parent: methodContext, identifier: nameIdentifier, accessedUsingSelf: true, position: node.position.utf8Offset)
        } else {
            _ = VariableAccessContext(parent: methodContext, identifier: baseIdentifierExpr.identifier.text, accessedUsingSelf: false, position: node.position.utf8Offset)
        }

        return .visitChildren
    }

    override func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        let methodContext = currentMethodContext.last

        if (node.parent?.is(FunctionCallExprSyntax.self) ?? false) {
            methodContext?.methodCalls.insert(node.identifier.text)

            // A method call can be an initialization, so we need to add all of them as possible type couplings to be verified later
            currentCouplableContext?.possibleTypeCouplings.insert(node.trimmedDescription)
            return .skipChildren
        }

        guard let methodContext else {
            return .skipChildren
        }

        _ = VariableAccessContext(parent: methodContext, identifier: node.identifier.text, accessedUsingSelf: false, position: node.position.utf8Offset)

        return .skipChildren
    }

    override func visit(_ node: SimpleTypeIdentifierSyntax) -> SyntaxVisitorContinueKind  {
        currentCouplableContext?.possibleTypeCouplings.insert(node.trimmedDescription)

        return .skipChildren
    }

    // MARK: Ignored visits

    override func visit(_ node: MissingDeclSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: AccessorDeclSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: AvailabilitySpecListSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: AvailabilityArgumentSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: AvailabilityVersionRestrictionListSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: AvailabilityVersionRestrictionListEntrySyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind  { return .skipChildren }
    override func visit(_ node: OperatorDeclSyntax) -> SyntaxVisitorContinueKind { return .skipChildren }
    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind { return .skipChildren }
    override func visit(_ node: ClosureSignatureSyntax) -> SyntaxVisitorContinueKind { return .skipChildren }
    override func visit(_ node: MacroDeclSyntax) -> SyntaxVisitorContinueKind { return .skipChildren }

    // MARK: - Private methods

    private func isStatic(modifiers: ModifierListSyntax?) -> Bool {
        guard let modifiers = modifiers else {
            return false
        }

        for modifier in modifiers {
            if case .keyword(SwiftSyntax.Keyword.static) = modifier.name.tokenKind {
                return true
            }
        }

        return false
    }

    private func firstInheritedType(for inheritanceClause: TypeInheritanceClauseSyntax?) -> String? {
        inheritanceClause?.inheritedTypeCollection.first?.typeName.trimmedDescription
    }

}
