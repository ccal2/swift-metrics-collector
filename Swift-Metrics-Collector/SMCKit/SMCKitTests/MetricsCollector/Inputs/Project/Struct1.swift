//
//  Struct1.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 04/07/23.
//

struct Struct1 {

    var x: Double = 0.0
    var y: Double = 0.0

    func foo() -> Bool {
        print("(\(x), \(self.y))")
        return x < y
    }

}
