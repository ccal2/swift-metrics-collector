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
            }
        }
    }

    // Since a method can be defined inside another method, the currentMethodContext is represented by an array that is used as a stack
    var currentMethodContext: [MethodContext] = []

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
        currentContext = parentContext
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        let variableDeclContext = VariableDeclarationContext(parent: currentContext, isStatic: isStatic(modifiers: node.modifiers))
        currentContext = variableDeclContext

        return .visitChildren
    }

    override func visitPost(_ node: VariableDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        currentContext = parentContext
    }

    override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
        if let variableDeclContext = currentContext as? VariableDeclarationContext {
            variableDeclContext.identifier = node.identifier.text
        }
        // else...

        return .skipChildren
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
            assertionFailure("The current context must be a MethodContext")
            return .skipChildren
        }

        _ = MethodParameterContext(parent: methodContext,
                                   firstName: node.firstName?.text,
                                   secondName: node.secondName?.text,
                                   typeIdentifier:  node.type?.trimmedDescription)

        return .skipChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        // Member accesses outside of a method context are not relevant to this tool
        guard let methodContext = currentMethodContext.last else {
            return .visitChildren
        }

        let nameToken = node.name

        if node.parent?.is(FunctionCallExprSyntax.self) ?? false {
            guard case let .identifier(nameIdentifier) = nameToken.tokenKind else {
                return .visitChildren
            }
            methodContext.methodCalls.insert(nameIdentifier)
        }

        guard let baseIdentifierExpr = node.base?.as(IdentifierExprSyntax.self) else {
            return .visitChildren
        }

        if baseIdentifierExpr.identifier.tokenKind == .keyword(.self) {
            guard case let .identifier(nameIdentifier) = nameToken.tokenKind,
                  !(node.parent?.is(FunctionCallExprSyntax.self) ?? false) else {
                return .skipChildren
            }

            _ = VariableAccessContext(parent: methodContext, identifier: nameIdentifier, accessedUsingSelf: true)
        } else {
            _ = VariableAccessContext(parent: methodContext, identifier: baseIdentifierExpr.identifier.text, accessedUsingSelf: false)
        }

        return .visitChildren
    }

    override func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        // Identifier expressions outside of a method context are not relevant to this tool
        guard let methodContext = currentMethodContext.last else {
            return .skipChildren
        }

        if (node.parent?.is(FunctionCallExprSyntax.self) ?? false) {
            methodContext.methodCalls.insert(node.identifier.text)
        } else {
            _ = VariableAccessContext(parent: methodContext, identifier: node.identifier.text, accessedUsingSelf: false)
        }

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
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind { return .skipChildren }
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
