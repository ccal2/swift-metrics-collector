//
//  ClassInheritanceNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class ClassInheritanceNode: TreeNode {

    let context: ClassContext
    private(set) weak var parent: ClassInheritanceNode?
    private(set) var children: [ClassInheritanceNode] = []

    var identifier: String {
        context.fullIdentifier
    }

    var numberOfChildren: Int {
        children.count
    }

    var depthOfInheritance: Int {
        var depth = 0

        var node = self
        while let parent = node.parent {
            depth += 1
            node = parent
        }

        return depth
    }

    init(parent: ClassInheritanceNode?, context: ClassContext) {
        self.parent = parent
        self.context = context
        parent?.children.append(self)
    }

    func printWithChildren(prefix: String = "") {
        print(prefix + identifier + " (NOC: \(numberOfChildren) | DIT: \(depthOfInheritance))")
        for child in children {
            child.printWithChildren(prefix: prefix + "\t")
        }
    }

}
