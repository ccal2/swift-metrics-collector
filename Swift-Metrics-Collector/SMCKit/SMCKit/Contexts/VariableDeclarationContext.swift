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

    // MARK: - Initializers

    init(parent: Context, identifier: String, isStatic: Bool) {
        self.identifier = identifier
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}
