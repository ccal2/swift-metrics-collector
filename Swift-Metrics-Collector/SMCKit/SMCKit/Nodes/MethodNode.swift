//
//  MethodNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodNode: ContainerNode<MethodContext> {

    // MARK: - Properties

    var methodCalls: Set<String> {
        context.methodCalls
    }

    private(set) lazy var identifier: String = {
        context.identifier
    }()

    private(set) lazy var isStatic: Bool  = {
        context.isStatic
    }()

    private(set) lazy var parameters: Set<MethodParameterNode> = {
        var parameters: Set<MethodParameterNode> = []

        for context in context.parameters {
            parameters.insert(MethodParameterNode(parent: self, context: context))
        }

        return parameters
    }()

    private(set) lazy var returnTypeIdentifier: String? = {
        context.returnTypeIdentifier
    }()

    private(set) lazy var variableAccesses: Set<VariableAccessNode> = {
        var variableAccesses: Set<VariableAccessNode> = []

        for accessContext in context.variableAccesses {
            variableAccesses.insert(VariableAccessNode(parent: self, context: accessContext))
        }

        return variableAccesses
    }()

    // If an instance variable is accessed without self and later on a local variable is declared with the same name, that access will be ignored!
    // To fix this, we'd need to save the indexes of the declarataion and the access and use that when identifing wheter an access is related to an instance variable or not
    private(set) lazy var accessedInstanceVariables: Set<VariableNode> = {
        // localVariables will store all variables declared inside this method or any other method that includes it (until the type delcaration is reached)
        // e.g.: class A { func fA() { class B { func fB() { func gB() {} } } } } | object is method f: all variables declared in methods f and g
        var localVariables = variables

        var node = parent
        while let methodParent = node as? MethodNode {
            localVariables.formUnion(methodParent.variables)
            node = methodParent.parent
        }

        if node is TypeExtensionNode {
            node = node?.parent
        }

        guard let typeNode = node as? TypeNode else {
            return []
        }

        var instanceVariables: Set<VariableNode> = []
        for variableAccess in variableAccesses {
            if !variableAccess.accessedUsingSelf {
                guard localVariables.first(withIdentifier: variableAccess.identifier) == nil else {
                    continue
                }
            }

            guard let instanceVariable = typeNode.allNonStaticVariables.first(withIdentifier: variableAccess.identifier) else {
                continue
            }
            instanceVariables.insert(instanceVariable)
        }

        for child in methods {
            instanceVariables.formUnion(child.accessedInstanceVariables)
        }

        return instanceVariables
    }()

    // MARK: - Initializers

    init(parent: (any ContainerNodeObject)?, context: MethodContext) {
        super.init(parent: parent, context: context)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let parametersDescription = parameters.map { parameter in
            parameter.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let variableAccessesDescription = variableAccesses.map { variableAccess in
            variableAccess.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let accessedInstanceVariablesDescription = accessedInstanceVariables.map { instanceVariable in
            instanceVariable.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        return """
        \(prefix)Method: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\tisStatic: \(isStatic)
        \(prefix)\tparameters: [
        \(parametersDescription)
        \(prefix)\t],
        \(prefix)\treturnTypeIdentifier: \(returnTypeIdentifier ?? "nil"),
        \(prefix)\tvariables: [
        \(variablesDescription)
        \(prefix)\t],
        \(prefix)\tmethods: [
        \(methodsDescription)
        \(prefix)\t],
        \(prefix)\tvariable accesses: [
        \(variableAccessesDescription)
        \(prefix)\t],
        \(prefix)\taccessed instance variables: [
        \(accessedInstanceVariablesDescription)
        \(prefix)\t]
        \(prefix)}
        """
    }

}


// MARK: - CustomStringConvertible

extension MethodNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
