//
//  Class4.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 04/07/23.
//

class Class4: Class1, Protocol1 {

    var variableB: Double

    init(a: Double, b: Double) {
        self.variableB = b
        super.init(a: a)
    }

    func foo(someObject: Protocol1) {
        doSomething()

        let object = Class2(b: 2.0, c: "c", a: 42.0)

        print(methodA(param: object.variableC))

        print(someObject.variableB + 5.0)
    }

    func bar() -> Double {
        return self.add(b: self.variableB)
    }

    func anotherFunc() {
        print(2.3 + variableB)
        print(constA)
    }

    func oneMoreFunc() {
        print(methodA(param: constA))
    }

}
