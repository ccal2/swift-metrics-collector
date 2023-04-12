//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class ClassNode: TypeNode { }

class TypeNode: BlockNode {

    // MARK: - Properties

    let context: TypeContext

    private(set) weak var parent: TypeNode?
    private(set) var children: [TypeNode] = []

    private(set) lazy var identifier: String = {
        context.fullIdentifier
    }()

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

    private(set) lazy var depthOfInheritance: Int = {
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
        super.init()

        parent?.children.append(self)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let childrenDescription = children.map { child in
            child.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        return """
        \(prefix)Type: {
        \(prefix)   identifier: \(identifier)
        \(prefix)   children: [
        \(childrenDescription)
        \(prefix)   ],
        \(prefix)   variables: [
        \(variablesDescription)
        \(prefix)   ],
        \(prefix)   methods: [
        \(methodsDescription)
        \(prefix)   ],
        \(prefix)   NOC: \(numberOfChildren),
        \(prefix)   DIT: \(depthOfInheritance)
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension TypeNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
