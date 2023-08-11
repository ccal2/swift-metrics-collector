//
//  VariableDeclarationContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableDeclarationContext: Context {

    // MARK: - Properties

    let identifier: String
    let isStatic: Bool
    let position: Int

    // MARK: - Initializers

    init(parent: Context, identifier: String, isStatic: Bool, position: Int) {
        self.identifier = identifier
        self.isStatic = isStatic
        self.position = position
        super.init(parent: parent)
    }

}
