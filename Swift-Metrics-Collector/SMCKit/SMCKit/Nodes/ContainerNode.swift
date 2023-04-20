//
//  ContainerNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 12/04/23.
//

protocol ContainerNodeObject: NodeObject {
    var variables: [VariableNode] { get }
    var methods: [MethodNode] { get }
}

class ContainerNode<ContextType: Context>: Node<ContextType>, ContainerNodeObject {

    private(set) lazy var variables: [VariableNode] = {
        context.variableDeclarations.map { context in
            VariableNode(parent: self, context: context)
        }
    }()

    private(set) lazy var methods: [MethodNode]  = {
        context.methods.map { context in
            MethodNode(parent: self, context: context)
        }
    }()

}
