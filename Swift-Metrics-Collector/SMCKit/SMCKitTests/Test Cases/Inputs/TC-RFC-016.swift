//
//  TC-RFC-016.swift
//  SMCKit
//
//  Created by Carolina Lopes on 27/07/23.
//

func outerMethod1() -> String { "some" }
func outerMethod2() -> String { "thing" }
func outerMethod3() -> String { "something" }
func outerMethod4() -> String { "else" }
func outerMethod5(param1: String, param2: String) -> String {
    [param1, param2].joined(separator:" ")
}

class Class1 {
    func method1() {
        print(outerMethod1().uppercased() + outerMethod2())
        print([outerMethod3(), outerMethod4()].joined(separator:" "))
        print(outerMethod5(param1: outerMethod3(), param2: outerMethod4()))
    }
}
