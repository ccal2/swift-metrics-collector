//
//  Context.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class Context: TreeNode {

    private(set) weak var parent: Context?
    private(set) var children: [Context] = []

    init(parent: Context?) {
        self.parent = parent
        parent?.children.append(self)
    }

    var variableDeclarations: [VariableDeclarationContext] {
        var variables: [VariableDeclarationContext] = []

        for child in children {
            guard let variableDeclContext = child as? VariableDeclarationContext else {
                continue
            }

            variables.append(variableDeclContext)
        }

        return variables
    }

}

extension Context: Equatable {

    static func == (lhs: Context, rhs: Context) -> Bool {
        lhs === rhs
    }

}
