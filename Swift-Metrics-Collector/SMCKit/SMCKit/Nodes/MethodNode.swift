//
//  MethodNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodNode: ContainerNode {

    // MARK: - Properties

    let context: MethodContext

    private(set) weak var parent: ContainerNode?

    private(set) lazy var identifier: String = {
        context.identifier
    }()

    private(set) lazy var isStatic: Bool  = {
        context.isStatic
    }()

    private(set) lazy var parameters: [MethodParameterNode]  = {
        context.parameters.map { context in
            MethodParameterNode(parent: self, context: context)
        }
    }()

    private(set) lazy var returnTypeIdentifier: String? = {
        context.returnTypeIdentifier
    }()

    private(set) lazy var variables: [VariableNode] = {
        context.variableDeclarations.map { context in
            VariableNode(parent: self, context: context)
        }
    }()

    private(set) lazy var variableAccesses: [VariableAccessNode] = {
        context.variableAccesses.map { context in
            VariableAccessNode(parent: self, context: context)
        }
    }()

    // If an instance variable is accessed without self and later on a local variable is declared with the same name, that access will be ignored!
    // To fix this, we'd need to save the indexes of the declarataion and the access and use that when identifing wheter an access is related to an instance variable or not
    private(set) lazy var accessedInstanceVariables: Set<VariableNode> = {
        // TODO: look for TypeNode parent recursively
        //      To do that, it might be needed to create e Node superclass, so that there's always a `parent` variable
        guard let typeNode = parent as? TypeNode else {
            return []
        }

        var instanceVariables: Set<VariableNode> = []
        for variableAccess in variableAccesses {
            if let localVariable = variables.first(withIdentifier: variableAccess.identifier) {
                guard variableAccess.accessedUsingSelf else {
                    continue
                }
                instanceVariables.insert(localVariable)
            } else {
                guard let instanceVariable = typeNode.nonStaticVariables.first(withIdentifier: variableAccess.identifier) else {
                    continue
                }
                instanceVariables.insert(instanceVariable)
            }
        }

        return instanceVariables
    }()

    // MARK: - Initializers

    init(parent: ContainerNode?, context: MethodContext) {
        self.parent = parent
        self.context = context
        super.init()
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let parametersDescription = parameters.map { parameter in
            parameter.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let variableAccessesDescription = variableAccesses.map { variableAccess in
            variableAccess.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let accessedInstanceVariablesDescription = accessedInstanceVariables.map { instanceVariable in
            instanceVariable.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        return """
        \(prefix)Method: {
        \(prefix)   identifier: \(identifier),
        \(prefix)   isStatic: \(isStatic)
        \(prefix)   parameters: [
        \(parametersDescription)
        \(prefix)   ],
        \(prefix)   returnTypeIdentifier: \(returnTypeIdentifier ?? "nil"),
        \(prefix)   variables: [
        \(variablesDescription)
        \(prefix)   ]
        \(prefix)   variable accesses: [
        \(variableAccessesDescription)
        \(prefix)   ]
        \(prefix)   accessed instance variables: [
        \(accessedInstanceVariablesDescription)
        \(prefix)   ]
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
