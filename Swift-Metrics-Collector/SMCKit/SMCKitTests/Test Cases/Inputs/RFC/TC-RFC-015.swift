//
//  TC-RFC-015.swift
//  SMCKit
//
//  Created by Carolina Lopes on 27/07/23.
//

func outerMethod1() { }
func outerMethod2() { }
func outerMethod3() { }

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
class Class2: Class1 {
    func method6() {
        outerMethod2()
        outerMethod3()
    }
    func method7() {
        outerMethod1()
    }
    func method8() { }
}
