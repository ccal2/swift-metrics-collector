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

    var methodCalls: Set<String> = []

    // MARK: Computed properties

    var parameters: Set<MethodParameterContext> {
        var parameters: Set<MethodParameterContext> = []

        for context in children {
            if let parameter = context as? MethodParameterContext {
                parameters.insert(parameter)
            }
        }

        return parameters
    }

    var variableAccesses: Set<VariableAccessContext> {
        var variableAccesses: Set<VariableAccessContext> = []

        for context in children {
            if let variableAccess = context as? VariableAccessContext {
                variableAccesses.insert(variableAccess)
            }
        }

        return variableAccesses
    }

    // MARK: - Initializers

    init(parent: Context, identifier: String, returnTypeIdentifier: String?, isStatic: Bool) {
        self.identifier = identifier
        self.returnTypeIdentifier = returnTypeIdentifier
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}
