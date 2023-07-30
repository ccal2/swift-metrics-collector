//
//  Node.swift
//  SMCKit
//
//  Created by Carolina Lopes on 19/04/23.
//

class Node {

    // MARK: - Properties

    private(set) weak var parent: Node?

    let uuid = UUID()

    // MARK: - Initializers

    init(parent: Node?) {
        self.parent = parent
    }


    // MARK: - Hashable

    // Declared here so it can be overridden by subclasses
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

}

// MARK: - Hashable

extension Node: Hashable {

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.uuid == rhs.uuid
    }

}

