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

}
