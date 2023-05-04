//
//  TypeExtensionContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 26/04/23.
//

class TypeExtensionContext: Context {

    // MARK: - Properties

    let identifier: String

    // MARK: - Initializers

    init(parent: Context, identifier: String) {
        self.identifier = identifier
        super.init(parent: parent)
    }
    
}
