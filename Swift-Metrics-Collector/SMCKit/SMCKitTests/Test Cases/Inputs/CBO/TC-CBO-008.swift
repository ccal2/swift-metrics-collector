//
//  TC-CBO-008.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 30/07/23.
//

class Class1 { }
class Class2 { }
class Class3 { }
class Class4 {
    init(param1: Class1) { }

    func method1(param1: Class2, param2: Class5) { }

    static func method2(param1: Class6) { }
}
class Class5 { }
class Class6 { }

extension Class4 {
    func method3(param1: Class2, param2: Class5) { }

    static func method4(param1: Class6) { }
}
