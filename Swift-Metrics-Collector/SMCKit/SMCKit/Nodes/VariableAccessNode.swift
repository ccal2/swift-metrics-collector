//
//  VariableAccessNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 18/04/23.
//

class VariableAccessNode: Node {

    // MARK: - Properties

    let identifier: String
    let accessedUsingSelf: Bool
    let position: Int

    // MARK: - Initializers

    init(parent: MethodNode?, context: VariableAccessContext) {
        self.identifier = context.identifier
        self.accessedUsingSelf = context.accessedUsingSelf
        self.position = context.position

        super.init(parent: parent)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        return """
        \(prefix)Variable access: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\taccessedUsingSelf: \(accessedUsingSelf),
        \(prefix)\tposition: \(position)
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension VariableAccessNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
