//
//  MethodParameterContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodParameterContext: Context {

    // MARK: - Properties

    let firstName: String?
    let secondName: String?
    let typeIdentifier: String?

    // MARK: - Initializers

    init(parent: MethodContext, firstName: String?, secondName: String?, typeIdentifier: String?) {
        self.firstName = firstName
        self.secondName = secondName
        self.typeIdentifier = typeIdentifier
        super.init(parent: parent)
    }

}
