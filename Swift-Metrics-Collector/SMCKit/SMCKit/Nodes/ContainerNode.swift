//
//  ContainerNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 12/04/23.
//

protocol ContainerNodeObject: NodeObject {
    var variables: Set<VariableNode> { get }
    var methods: Set<MethodNode> { get }
}

class ContainerNode<ContextType: Context>: Node<ContextType>, ContainerNodeObject {

    private(set) lazy var variables: Set<VariableNode> = {
        var variables: Set<VariableNode> = []

        for context in context.variableDeclarations {
            variables.insert(VariableNode(parent: self, context: context))
        }

        return variables
    }()

    private(set) lazy var methods: Set<MethodNode>  = {
        var methods: Set<MethodNode> = []

        for context in context.methods {
            methods.insert(MethodNode(parent: self, context: context))
        }

        return methods
    }()

}
