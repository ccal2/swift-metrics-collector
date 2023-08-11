//
//  VariableAccessContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 18/04/23.
//

class VariableAccessContext: Context {

    // MARK: - Properties

    let identifier: String
    let accessedUsingSelf: Bool
    let position: Int

    // MARK: - Initializers

    init(parent: MethodContext, identifier: String, accessedUsingSelf: Bool, position: Int) {
        self.identifier = identifier
        self.accessedUsingSelf = accessedUsingSelf
        self.position = position
        super.init(parent: parent)
    }

}
