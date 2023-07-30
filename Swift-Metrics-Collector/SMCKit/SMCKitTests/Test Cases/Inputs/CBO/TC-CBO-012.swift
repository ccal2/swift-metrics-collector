//
//  TC-CBO-012.swift
//  SMCKit
//
//  Created by Carolina Lopes on 30/07/23.
//

class Class1 { }
class Class2 { }
class Class3 { }
class Class4 {
    var variable1: Class1 = .init()

    init() {
        let object1: Class2 = .init()
    }

    func method1() {
        let object1: Class5 = .init()
    }

    static func method2() {
        let object1: Class6 = .init()
    }
}
class Class5 { }
class Class6 { }

extension Class4 {
    var variable2: Class1 { variable1 }

    func method3() {
        let object1: Class5 = .init()
    }

    static func method4() {
        let object1: Class6 = .init()
    }
}
