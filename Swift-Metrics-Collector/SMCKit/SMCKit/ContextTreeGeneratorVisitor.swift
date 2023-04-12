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

    // MARK: Visit overrides

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let identifier = node.identifier.text
        let firstInheritedType = firstInheritedType(for: node.inheritanceClause)

        let classContext = ClassContext(parent: currentContext, identifier: identifier, firstInheritedType: firstInheritedType)
        currentContext = classContext

        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
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

    override func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        guard let methodContext = currentContext as? MethodContext else {
            assertionFailure("The current context must be a MethodContext")
            return .visitChildren
        }

        let parameterContext = MethodParameterContext(parent: methodContext,
                                                      firstName: node.firstName?.text,
                                                      secondName: node.secondName?.text,
                                                      typeIdentifier:  typeIdentifier(for: node.type))
        currentContext = parameterContext

        return .skipChildren
    }

    override func visitPost(_ node: FunctionParameterSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil after visiting something because there will always be the global context")
        }
        currentContext = parentContext
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
