//
//  Context.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class Context {

    // MARK: - Properties

    private(set) weak var parent: Context?
    private(set) var children: [Context] = []

    // MARK: Computed properties

    var variableDeclarations: [VariableDeclarationContext] {
        children.compactMap { context in
            context as? VariableDeclarationContext
        }
    }

    var methods: [MethodContext] {
        children.compactMap { context in
            context as? MethodContext
        }
    }

    // MARK: - Initializers

    init(parent: Context?) {
        self.parent = parent
        parent?.children.append(self)
    }

}

// MARK: - Equatable

extension Context: Equatable {

    static func == (lhs: Context, rhs: Context) -> Bool {
        lhs === rhs
    }

}
