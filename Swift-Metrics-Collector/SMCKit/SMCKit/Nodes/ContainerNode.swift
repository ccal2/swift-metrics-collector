//
//  ContainerNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 12/04/23.
//

class ContainerNode: Node {

    // MARK: - Properties

    private(set) var variables: Set<VariableNode> = []
    private(set) var methods: Set<MethodNode> = []

    // MARK: - Initializers

    init(parent: Node?, context: Context) {
        super.init(parent: parent)

        for context in context.variableDeclarations {
            self.variables.insert(VariableNode(parent: self, context: context))
        }
        for context in context.methods {
            self.methods.insert(MethodNode(parent: self, context: context))
        }
    }

}
