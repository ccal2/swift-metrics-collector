//
//  VariableNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableNode: CustomStringConvertible {

    let context: VariableDeclarationContext

    var identifier: String {
        guard let identifier = context.identifier else {
            fatalError("The variable identifier must be set before initializing the VariableNode")
        }

        return identifier
    }

    var isStatic: Bool {
        context.isStatic
    }

    var description: String {
        let postfix = isStatic ? " (static)" : ""
        return identifier + postfix
    }

    init(context: VariableDeclarationContext) {
        self.context = context
    }

}
