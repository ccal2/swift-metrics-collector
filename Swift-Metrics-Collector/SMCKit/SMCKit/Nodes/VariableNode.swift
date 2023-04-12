//
//  VariableNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableNode: CustomStringConvertible {

    // MARK: - Properties

    let context: VariableDeclarationContext

    lazy var identifier: String = {
        guard let identifier = context.identifier else {
            fatalError("The variable identifier must be set before initializing the VariableNode")
        }

        return identifier
    }()

    lazy var isStatic: Bool = {
        context.isStatic
    }()

    lazy var description: String = {
        let postfix = isStatic ? " (static)" : ""
        return identifier + postfix
    }()

    // MARK: - Initializers

    init(context: VariableDeclarationContext) {
        self.context = context
    }

}
