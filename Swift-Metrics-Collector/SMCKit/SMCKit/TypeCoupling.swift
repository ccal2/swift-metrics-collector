//
//  TypeCoupling.swift
//  SMCKit
//
//  Created by Carolina Lopes on 29/07/23.
//

struct TypeCoupling {
    let types: (TypeNode, TypeNode)

    func contains(_ type: TypeNode) -> Bool {
        types.0 == type || types.1 == type
    }
}

extension TypeCoupling: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(Set([types.0.uuid, types.1.uuid]))
    }

    static func == (lhs: TypeCoupling, rhs: TypeCoupling) -> Bool {
        lhs.types.0 == rhs.types.0 && lhs.types.1 == rhs.types.1 ||
        lhs.types.0 == rhs.types.1 && lhs.types.1 == rhs.types.0
    }

}
