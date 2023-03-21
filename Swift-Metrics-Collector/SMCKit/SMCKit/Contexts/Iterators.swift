//
//  Iterators.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

struct ContextDepthPreOrderIterator: IteratorProtocol {
    typealias Element = Context

    private var currentNode: Element?
    private var queue: [Element] = []

    init(root: Element) {
        self.currentNode = root
    }

    mutating func next() -> Element? {
        defer {
            if let currentNode {
                queue.insert(contentsOf: currentNode.children, at: 0)
            }

            currentNode = queue.isEmpty ? nil : queue.removeFirst()
        }

        return currentNode
    }

}

struct ContextBreadthIterator: IteratorProtocol {
    typealias Element = Context

    private var currentNode: Element?
    private var queue: [Element] = []

    init(root: Element) {
        self.currentNode = root
    }

    mutating func next() -> Element? {
        defer {
            if let currentNode {
                queue.append(contentsOf: currentNode.children)
            }

            currentNode = queue.isEmpty ? nil : queue.removeFirst()
        }

        return currentNode
    }

}
