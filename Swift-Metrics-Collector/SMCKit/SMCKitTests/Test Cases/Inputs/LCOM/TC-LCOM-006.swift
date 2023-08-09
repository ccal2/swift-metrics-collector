//
//  TC-LCOM-006.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 08/08/23.
//

class Class1 {
    var variable1: Double = 42.0
    var variable2 = true
    var variable3 = "something"
    var variable4 = [1, 2, 3]

    func method1() {
        if variable2 {
            print(variable1)
        }
    }
    func method2() {
        if variable2 {
            print(variable3)
        }
    }
    func method3() {
        for _ in variable4 {
            print(self.variable3)
        }
    }
}
