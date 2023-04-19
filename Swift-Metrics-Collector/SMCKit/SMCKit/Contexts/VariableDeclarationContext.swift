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

    private let uuid = UUID()

    // MARK: - Initializers

    init(parent: Context, isStatic: Bool) {
        self.isStatic = isStatic
        super.init(parent: parent)
    }

}

// MARK: - Hashable

extension VariableDeclarationContext: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: VariableDeclarationContext, rhs: VariableDeclarationContext) -> Bool {
        lhs.uuid == rhs.uuid
    }

}
