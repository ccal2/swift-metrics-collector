//
//  Couplable.swift
//  SMCKit
//
//  Created by Carolina Lopes on 29/07/23.
//

protocol Couplable: AnyObject {
    var possibleTypeCouplings: Set<String> { get set }
}
