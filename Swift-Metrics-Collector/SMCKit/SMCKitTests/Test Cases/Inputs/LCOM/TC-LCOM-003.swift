//
//  TC-LCOM-003.swift
//  SMCKit
//
//  Created by Carolina Lopes on 08/08/23.
//

class Class1 {
    var variable1: Double = 42.0

    static var variable2 = true

    func method1() {
        print(variable1)
        print(Self.variable2)
    }
    func method2() -> Double {
        variable1
    }
    func method3() {
        if Self.variable2 {
            print("yes")
        }
    }
}
