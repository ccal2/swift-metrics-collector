//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class ClassNode: TypeNode { }

class TypeNode {

    // MARK: - Properties

    let context: TypeContext

    private(set) weak var parent: TypeNode?
    private(set) var children: [TypeNode] = []
    private(set) var variables: [VariableNode] = []

    lazy var identifier: String = {
        context.fullIdentifier
    }()

    lazy var depthOfInheritance: Int = {
        var depth = 0

        var node = self
        while let parent = node.parent {
            depth += 1
            node = parent
        }

        return depth
    }()

    // MARK: Computed properties

    var numberOfChildren: Int {
        children.count
    }

    // MARK: - Initializers

    init(parent: TypeNode?, context: TypeContext) {
        self.parent = parent
        self.context = context
        self.variables = context.variableDeclarations.map(VariableNode.init)
        parent?.children.append(self)
    }

    // MARK: - Methods

    func printWithChildren(prefix: String = "") {
        print(prefix + identifier + " (NOC: \(numberOfChildren) | DIT: \(depthOfInheritance))")
        print(prefix + "\t variables: \(variables)")
        for child in children {
            child.printWithChildren(prefix: prefix + "\t")
        }
    }

}
