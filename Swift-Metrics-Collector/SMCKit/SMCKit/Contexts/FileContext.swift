//
//  FileContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 25/04/23.
//

class FileContext: Context {

    // MARK: - Properties

    let identifier: String

    // MARK: - Initializers

    init(parent: Context, identifier: String) {
        self.identifier = identifier
        super.init(parent: parent)
    }
    
}
