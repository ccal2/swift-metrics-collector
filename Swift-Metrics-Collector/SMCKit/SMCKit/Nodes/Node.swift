//
//  Node.swift
//  SMCKit
//
//  Created by Carolina Lopes on 19/04/23.
//

protocol NodeObject: AnyObject {
    associatedtype ContextType: Context

    var context: ContextType { get }
    var parent: (any NodeObject)? { get }
}

class Node<ContextType: Context>: NodeObject {
    typealias ContextType = ContextType

    // MARK: - Properties

    let context: ContextType
    private(set) weak var parent: (any NodeObject)?

    // MARK: - Initializers

    init(parent: (any NodeObject)?, context: ContextType) {
        self.parent = parent
        self.context = context
    }


    // MARK: - Hashable

    // Declared here so it can be overridden by subclasses
    func hash(into hasher: inout Hasher) {
        hasher.combine(context)
    }

}

// MARK: - Hashable

extension Node: Hashable {

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.context == rhs.context
    }

}

