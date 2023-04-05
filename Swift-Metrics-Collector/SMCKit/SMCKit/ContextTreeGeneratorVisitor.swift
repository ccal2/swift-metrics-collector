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
//        print("class declaration:")
//        dump(node)
//        print("------------")

        let identifier = node.identifier.text
        print("visiting class: '\(identifier)'")

        let firstInheritedType = firstInheritedType(for: node.inheritanceClause)
        print("\tfirstInheritedType: '\(firstInheritedType ?? "nil")'")

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
//        print("variable declaration:")
//        dump(node)
//        print("------------")

        let variableDeclContext = VariableDeclarationContext(parent: currentContext, isStatic: isStatic(variableDeclaration: node))
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
            print("visiting variable declaration: '\(node.identifier.text)'")
            print("\tisStatic: \(variableDeclContext.isStatic)")
        }
        // else...

        return .skipChildren
    }

    // MARK: Helpers

    private func isStatic(variableDeclaration node: VariableDeclSyntax) -> Bool {
        guard let modifiers = node.modifiers else {
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
        let typeName = inheritanceClause?.inheritedTypeCollection.first?.typeName

        if let simpleTypeIdentifier = typeName?.as(SimpleTypeIdentifierSyntax.self) {
            return simpleTypeIdentifier.name.text
        } else if let memberTypeIdentifier = typeName?.as(MemberTypeIdentifierSyntax.self) {
            return memberTypeIdentifier.trimmedDescription
        } else {
            return nil
        }
    }

}
