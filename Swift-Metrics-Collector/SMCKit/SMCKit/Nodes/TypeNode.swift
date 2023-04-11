//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class ClassNode: TypeNode { }

class TypeNode {

    let context: TypeContext
    private(set) weak var parent: TypeNode?
    private(set) var children: [TypeNode] = []
    private(set) var variables: [VariableNode] = []

    var identifier: String {
        context.fullIdentifier
    }

    var numberOfChildren: Int {
        children.count
    }

    var depthOfInheritance: Int {
        var depth = 0

        var node = self
        while let parent = node.parent {
            depth += 1
            node = parent
        }

        return depth
    }

    init(parent: TypeNode?, context: TypeContext) {
        self.parent = parent
        self.context = context
        self.variables = context.variableDeclarations.map(VariableNode.init)
        parent?.children.append(self)
    }

    func printWithChildren(prefix: String = "") {
        print(prefix + identifier + " (NOC: \(numberOfChildren) | DIT: \(depthOfInheritance))")
        print(prefix + "\t variables: \(variables)")
        for child in children {
            child.printWithChildren(prefix: prefix + "\t")
        }
    }

}