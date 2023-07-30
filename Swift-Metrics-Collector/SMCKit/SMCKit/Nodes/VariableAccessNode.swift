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

    // MARK: - Initializers

    init(parent: MethodNode?, context: VariableAccessContext) {
        self.identifier = context.identifier
        self.accessedUsingSelf = context.accessedUsingSelf

        super.init(parent: parent)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        return """
        \(prefix)Variable access: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\taccessedUsingSelf: \(accessedUsingSelf)
        \(prefix)}
        """
    }

    // MARK: - Hashable

    // Declared here so it can be overridden
    override func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(accessedUsingSelf)
    }

}

// MARK: - CustomStringConvertible

extension VariableAccessNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}

// MARK: - Hashable

extension VariableAccessNode {

    static func == (lhs: VariableAccessNode, rhs: VariableAccessNode) -> Bool {
        lhs.identifier == rhs.identifier && lhs.accessedUsingSelf == rhs.accessedUsingSelf
    }

}
