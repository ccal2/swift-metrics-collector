//
//  VariableDeclarationContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/04/23.
//

class VariableDeclarationContext: Context {

    var identifier: String?
    let isStatic: Bool

    init(parent: Context, isStatic: Bool) {
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}
