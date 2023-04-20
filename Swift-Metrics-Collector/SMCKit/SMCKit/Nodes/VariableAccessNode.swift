//
//  VariableAccessNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 18/04/23.
//

class VariableAccessNode: Node<VariableAccessContext> {

    // MARK: - Properties

    private(set) lazy var identifier: String = {
        context.identifier
    }()

    private(set) lazy var accessedUsingSelf: Bool = {
        context.accessedUsingSelf
    }()

    // MARK: - Initializers

    init(parent: MethodNode?, context: VariableAccessContext) {
        super.init(parent: parent, context: context)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        return """
        \(prefix)Variable access: {
        \(prefix)   identifier: \(identifier),
        \(prefix)   accessedUsingSelf: \(accessedUsingSelf)
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

// MARK: - Hashable

extension VariableAccessNode: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(accessedUsingSelf)
    }

    static func == (lhs: VariableAccessNode, rhs: VariableAccessNode) -> Bool {
        lhs.identifier == rhs.identifier && lhs.accessedUsingSelf == rhs.accessedUsingSelf
    }

}
