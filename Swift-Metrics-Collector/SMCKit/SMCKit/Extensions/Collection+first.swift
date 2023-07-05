//
//  Collection+first.swift
//  SMCKit
//
//  Created by Carolina Lopes on 18/04/23.
//

extension Collection where Element == VariableNode {

    func first(withIdentifier identifier: String) -> VariableNode? {
        first { node in
            node.identifier == identifier
        }
    }

}
