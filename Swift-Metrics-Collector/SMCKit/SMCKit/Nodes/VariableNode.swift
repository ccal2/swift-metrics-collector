//
//  VariableNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableNode: Node  {

    // MARK: - Properties

    let identifier: String
    let isStatic: Bool
    let position: Int

    // MARK: - Initializers

    init(parent: Node?, context: VariableDeclarationContext) {
        self.identifier = context.identifier
        self.isStatic = context.isStatic
        self.position = context.position

        super.init(parent: parent)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        return """
        \(prefix)Variable: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\tisStatic: \(isStatic),
        \(prefix)\tposition: \(position)
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension VariableNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
