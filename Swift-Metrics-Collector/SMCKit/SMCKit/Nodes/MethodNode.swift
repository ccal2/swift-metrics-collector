//
//  MethodNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodNode: ContainerNode {

    // MARK: - Properties

    let methodCalls: Set<String>
    let identifier: String
    let isStatic: Bool
    let returnTypeIdentifier: String?

    private(set) var parameters: Set<MethodParameterNode> = []
    private(set) var variableAccesses: Set<VariableAccessNode> = []

    // [Limitation]: If an instance variable is accessed without self and later on a local variable is declared with the same name, that access will be ignored!
    // To fix this, we'd need to save the indexes of the declaration and the access and use that when identifying whether an access is related to an instance variable or not
    private(set) lazy var accessedInstanceVariables: Set<VariableNode> = {
        // localVariables will store all variables declared inside this method or any other method that it includes (until the type declaration is reached)
        // e.g.: class A { func fA() { class B { func fB() { func gB() {} } } } } | object is method fB: all variables declared in methods fB and gB
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
            guard let instanceVariable = typeNode.allNonStaticVariables.first(withIdentifier: variableAccess.identifier) else {
                continue
            }

            if !variableAccess.accessedUsingSelf {
                var isLocal = false

                for localVariable in localVariables.filter(byIdentifier: variableAccess.identifier) {
                    guard localVariable.position > variableAccess.position else {
                        isLocal = true
                        break
                    }
                }

                if isLocal {
                    continue
                }
            }

            instanceVariables.insert(instanceVariable)
        }

        for child in methods {
            instanceVariables.formUnion(child.accessedInstanceVariables)
        }

        return instanceVariables
    }()

    // MARK: - Initializers

    init(parent: Node?, context: MethodContext) {
        self.methodCalls = context.methodCalls
        self.identifier = context.identifier
        self.isStatic = context.isStatic
        self.returnTypeIdentifier = context.returnTypeIdentifier

        super.init(parent: parent, context: context)

        for context in context.parameters {
            self.parameters.insert(MethodParameterNode(parent: self, context: context))
        }
        for accessContext in context.variableAccesses {
            self.variableAccesses.insert(VariableAccessNode(parent: self, context: accessContext))
        }
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        let parametersDescription = parameters.map { parameter in
            parameter.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let variablesDescription = variables.map { variable in
            variable.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let variableAccessesDescription = variableAccesses.map { variableAccess in
            variableAccess.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let accessedInstanceVariablesDescription = accessedInstanceVariables.map { instanceVariable in
            instanceVariable.printableDescription(indentationLevel: indentationLevel + 2)
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
