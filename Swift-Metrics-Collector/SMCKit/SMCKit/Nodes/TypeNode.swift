//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class TypeNode: ContainerNode<TypeContext> {

    // MARK: - Properties

    var extensions: Set<TypeExtensionNode> = []

    private(set) var children: Set<TypeNode> = []

    private(set) lazy var kind: TypeKind = {
        context.kind
    }()

    private(set) lazy var identifier: String = {
        context.fullIdentifier
    }()

    // MARK: Computed properties

    var variablesIncludingExtensions: Set<VariableNode> {
        var allVariables = variables

        extensions.forEach { node in
            allVariables.formUnion(node.variables)
        }

        return allVariables
    }

    var instanceVariablesIncludingExtensions: [VariableNode] {
        variablesIncludingExtensions.filter { node in
            !node.isStatic
        }
    }

    var allVariables: Set<VariableNode> {
        var allVariables = variablesIncludingExtensions

        if let parent = parent as? TypeNode {
            allVariables.formUnion(parent.allVariables)
        }

        return allVariables
    }

    var allNonStaticVariables: Set<VariableNode> {
        allVariables.filter { node in
            !node.isStatic
        }
    }

    var methodsIncludingExtensions: Set<MethodNode> {
        var allMethods = methods

        extensions.forEach { node in
            allMethods.formUnion(node.methods)
        }

        return allMethods
    }

    var instanceMethodsIncludingExtensions: [MethodNode] {
        methodsIncludingExtensions.filter { node in
            !node.isStatic
        }
    }

    var allInstanceMethods: Set<MethodNode> {
        var allMethods = Set(instanceMethodsIncludingExtensions)

        if let parent = parent as? TypeNode {
            allMethods.formUnion(parent.allInstanceMethods)
        }

        return allMethods
    }

    // MARK: - Initializers

    init(parent: TypeNode?, context: TypeContext) {
        super.init(parent: parent, context: context)

        parent?.children.insert(self)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        let variablesDescription = variables.map { variable in
            variable.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let extensionsDescription = extensions.map { `extension` in
            `extension`.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let childrenDescription = children.map { child in
            child.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let metrics = MetricsCalculator.calculateMetrics(for: self)

        return """
        \(prefix)Type: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\tvariables: [
        \(variablesDescription)
        \(prefix)\t],
        \(prefix)\tmethods: [
        \(methodsDescription)
        \(prefix)\t],
        \(prefix)\textensions: [
        \(extensionsDescription)
        \(prefix)\t],
        \(prefix)\tWMC: \(metrics.weightedMethodsPerClass),
        \(prefix)\tNOC: \(metrics.numberOfChildren),
        \(prefix)\tDIT: \(metrics.depthOfInheritance),
        \(prefix)\tLCOM: \(metrics.lackOfCohesionInMethods),
        \(prefix)\tRFC: \(metrics.responseForAClass),
        \(prefix)\tchildren: [
        \(childrenDescription)
        \(prefix)\t]
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
