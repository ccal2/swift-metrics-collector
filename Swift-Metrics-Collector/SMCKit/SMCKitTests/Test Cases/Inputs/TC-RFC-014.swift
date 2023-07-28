//
//  TC-RFC-014.swift
//  SMCKit
//
//  Created by Carolina Lopes on 27/07/23.
//

func outerMethod1() { }

class Class1 {
    func method1() {
        method3()
        print("something")
    }
    func method2() { }
    func method3() {
        print("else")
    }

    static func method4() { }
    static func method5() {
        outerMethod1()
    }
}
