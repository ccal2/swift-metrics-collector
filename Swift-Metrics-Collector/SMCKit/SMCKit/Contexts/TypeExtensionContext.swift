//
//  TypeExtensionContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 26/04/23.
//

class TypeExtensionContext: Context, Couplable {

    // MARK: - Properties

    let identifier: String

    var possibleTypeCouplings: Set<String> = []

    // MARK: - Initializers

    init(parent: Context, identifier: String) {
        self.identifier = identifier
        super.init(parent: parent)
    }
    
}
