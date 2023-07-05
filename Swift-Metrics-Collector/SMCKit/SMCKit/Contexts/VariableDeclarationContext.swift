//
//  VariableDeclarationContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableDeclarationContext: Context {

    // MARK: - Properties

    var identifier: String?
    let isStatic: Bool

    // MARK: - Initializers

    init(parent: Context, isStatic: Bool) {
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}
