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
