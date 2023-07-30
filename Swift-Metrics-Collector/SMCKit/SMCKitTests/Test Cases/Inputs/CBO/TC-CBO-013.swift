//
//  TC-CBO-013.swift
//  SMCKit
//
//  Created by Carolina Lopes on 30/07/23.
//

class Class1 { }
class Class2 { }
class Class3 { }
class Class4: Class1 {
    let variable1: Class1
    var variable2 = Class2()

    init(variable1: Class1) {
        self.variable1 = variable1
    }

    func method1(param1: Class5) { }

    static func method2() {
        let object1: Class6 = .init()
    }
}
class Class5 { }
class Class6 { }

extension Class4 {
    var variable3: Class2 { variable2 }

    func method3() {
        let object1: Class5 = .init()
    }

    static func method4() {
        let object1: Class6 = .init()
    }
}
