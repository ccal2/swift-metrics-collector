//
//  TreeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

protocol TreeNode {
    associatedtype Element

    var parent: Element? { get }
    var children: [Element] { get }
}
