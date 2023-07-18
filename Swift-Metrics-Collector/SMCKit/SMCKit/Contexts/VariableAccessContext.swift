//
//  VariableAccessContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 18/04/23.
//

class VariableAccessContext: Context {

    // MARK: - Properties

    let identifier: String
    let accessedUsingSelf: Bool

    // MARK: - Initializers

    init(parent: MethodContext, identifier: String, accessedUsingSelf: Bool) {
        self.identifier = identifier
        self.accessedUsingSelf = accessedUsingSelf
        super.init(parent: parent)
    }

    // MARK: - Hashable

    // Declared here so it can be overriden
    override func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(accessedUsingSelf)
    }

}

// MARK: - Hashable

extension VariableAccessContext {

    static func == (lhs: VariableAccessContext, rhs: VariableAccessContext) -> Bool {
        lhs.identifier == rhs.identifier && lhs.accessedUsingSelf == rhs.accessedUsingSelf
    }

}
