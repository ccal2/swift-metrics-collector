//
//  VariableNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableNode {

    // MARK: - Properties

    let context: VariableDeclarationContext

    private(set) weak var parent: BlockNode?

    private(set) lazy var identifier: String = {
        guard let identifier = context.identifier else {
            fatalError("The variable identifier must be set before initializing the VariableNode")
        }

        return identifier
    }()

    private(set) lazy var isStatic: Bool = {
        context.isStatic
    }()

    // MARK: - Initializers

    init(parent: BlockNode?, context: VariableDeclarationContext) {
        self.parent = parent
        self.context = context
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        return """
        \(prefix)Variable: {
        \(prefix)   identifier: \(identifier),
        \(prefix)   isStatic: \(isStatic)
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
