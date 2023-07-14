//
//  Class1.swift
//  SMCKit
//
//  Created by Carolina Lopes on 04/07/23.
//

class Class1 {

    var variableA: Double
    let constA = "a constant"

    static var staticVar = 2
    static let staticConst = "another constant"

    init(a: Double) {
        self.variableA = a
    }

    func add(b: Double) -> Double {
        variableA + b
    }

    func doSomething() {
        print("something + \(Self.staticConst)")
    }

    func methodA(param: String) -> String {
        print(variableA)
        return "\(constA) + \(param) = \(self.constA)\(param)"
    }

    func methodB() {
        // do nothing
    }

    static func staticMethod() -> Int {
        self.staticVar + 10
    }

}
