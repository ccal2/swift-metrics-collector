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

    private let uuid = UUID()

    // MARK: Computed properties

    var variableDeclarations: Set<VariableDeclarationContext> {
        var variableDeclarations: Set<VariableDeclarationContext> = []

        for context in children {
            if let variableDeclaration = context as? VariableDeclarationContext {
                variableDeclarations.insert(variableDeclaration)
            }
        }

        return variableDeclarations
    }

    var methods: Set<MethodContext> {
        var methods: Set<MethodContext> = []

        for context in children {
            if let method = context as? MethodContext {
                methods.insert(method)
            }
        }

        return methods
    }

    // MARK: - Initializers

    init(parent: Context?) {
        self.parent = parent
        parent?.children.append(self)
    }

    // MARK: - Hashable

    // Declared here so it can be overridden by subclasses
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

}

// MARK: - Hashable

extension Context: Hashable {

    static func == (lhs: Context, rhs: Context) -> Bool {
        lhs.uuid == rhs.uuid
    }

}
