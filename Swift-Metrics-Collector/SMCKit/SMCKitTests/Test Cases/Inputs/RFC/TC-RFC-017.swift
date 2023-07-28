//
//  TC-RFC-017.swift
//  SMCKit
//
//  Created by Carolina Lopes on 27/07/23.
//

class Class1 {
    func method1() {
        print("something")
    }
    func method2() { }
}
class Class2 {
    func method3() {
        let object1 = Class1()
        let object2 = Class1()
        object.method1()
        object.method2()
        object2.method2()
    }
}
