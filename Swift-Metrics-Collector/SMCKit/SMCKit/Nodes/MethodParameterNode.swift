//
//  MethodParameterNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodParameterNode: Node {

    // MARK: - Properties

    let label: String?
    let identifier: String
    let typeIdentifier: String

    // MARK: - Initializers

    init(parent: MethodNode, context: MethodParameterContext) {
        guard let type = context.typeIdentifier else {
            fatalError("Missing type identifier in parameter")
        }

        self.label = context.firstName
        if let secondName = context.secondName {
            self.identifier = secondName
        } else {
            guard let firstName = context.firstName else {
                fatalError("Missing identifier in parameter")
            }
            self.identifier = firstName
        }
        self.typeIdentifier = type

        super.init(parent: parent)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        return """
        \(prefix)Parameter: {
        \(prefix)\tlabel: \(label ?? "nil"),
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\ttypeIdentifier: \(typeIdentifier)
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension MethodParameterNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
