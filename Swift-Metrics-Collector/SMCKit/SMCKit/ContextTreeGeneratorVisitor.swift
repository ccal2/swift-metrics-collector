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
    lazy var currentContext: Context = rootContext

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
        // TODO: handle all types
        guard let identifier = node.extendedType.as(SimpleTypeIdentifierSyntax.self)?.name.text else {
            assertionFailure("Type not handled")
            return .skipChildren
        }

        let extensionContext = TypeExtensionContext(parent: currentContext, identifier: identifier)
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
                                          returnTypeIdentifier: typeIdentifier(for: node.signature.output?.returnType),
                                          isStatic: isStatic(modifiers: node.modifiers))
        currentContext = methodContext

        return .visitChildren
    }

    override func visitPost(_ node: FunctionDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        currentContext = parentContext
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        // Ignore initializers
        return .skipChildren
    }

    override func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        // Ignore enum case declarations
        return .skipChildren
    }

    override func visit(_ node: ClosureSignatureSyntax) -> SyntaxVisitorContinueKind {
        // Ignore closure signatures
        return .skipChildren
    }

    override func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        guard let methodContext = currentContext as? MethodContext else {
            assertionFailure("The current context must be a MethodContext")
            return .skipChildren
        }

        _ = MethodParameterContext(parent: methodContext,
                                   firstName: node.firstName?.text,
                                   secondName: node.secondName?.text,
                                   typeIdentifier:  typeIdentifier(for: node.type))

        return .skipChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let identifierExpr = node.base?.as(IdentifierExprSyntax.self) else {
            return .visitChildren
        }

        if identifierExpr.identifier.tokenKind == .keyword(.self) {
            guard let nameToken = node.name.as(TokenSyntax.self),
                  case let .identifier(nameIdentifier) = nameToken.tokenKind,
                  !(node.parent?.is(FunctionCallExprSyntax.self) ?? false) else {
                return .skipChildren
            }

            _ = VariableAccessContext(parent: currentContext, identifier: nameIdentifier, accessedUsingSelf: true)
        } else {
            _ = VariableAccessContext(parent: currentContext, identifier: identifierExpr.identifier.text, accessedUsingSelf: false)
        }

        return .skipChildren
    }

    override func visit(_ node: IdentifierExprSyntax) -> SyntaxVisitorContinueKind {
        if !(node.parent?.is(FunctionCallExprSyntax.self) ?? false) {
            _ = VariableAccessContext(parent: currentContext, identifier: node.identifier.text, accessedUsingSelf: false)
        }

        return .skipChildren
    }

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
        if let typeName = inheritanceClause?.inheritedTypeCollection.first?.typeName {
            return typeIdentifier(for: typeName)
        } else {
            return nil
        }
    }

    private func typeIdentifier(for type: TypeSyntax?) -> String? {
        if let simpleTypeIdentifier = type?.as(SimpleTypeIdentifierSyntax.self) {
            return simpleTypeIdentifier.name.text
        } else if let memberTypeIdentifier = type?.as(MemberTypeIdentifierSyntax.self) {
            return memberTypeIdentifier.trimmedDescription
        } else {
            return nil
        }
    }

}
