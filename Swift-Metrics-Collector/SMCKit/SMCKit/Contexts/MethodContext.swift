//
//  MethodContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodContext: Context {

    // MARK: - Properties

    let identifier: String
    let returnTypeIdentifier: String?
    let isStatic: Bool

    // MARK: Computed properties

    var parameters: [MethodParameterContext] {
        children.compactMap { context in
            context as? MethodParameterContext
        }
    }

    var variableAccesses: [VariableAccessContext] {
        children.compactMap { context in
            context as? VariableAccessContext
        }
    }

    // MARK: - Initializers

    init(parent: Context, identifier: String, returnTypeIdentifier: String?, isStatic: Bool) {
        self.identifier = identifier
        self.returnTypeIdentifier = returnTypeIdentifier
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}
