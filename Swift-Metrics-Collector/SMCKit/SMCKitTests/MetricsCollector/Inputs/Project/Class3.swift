//
//  Class3.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 04/07/23.
//

class Class3: Class2 {

    var object: Protocol1? = nil
    let anotherObject = Class4(a: 1.0, b: 2.5)

    var hasObject: Bool {
        object != nil
    }

    func aMethod() {
        variableD ? print("true") : print("false")
    }

    func bMethod() {
        let result = self.someMethod(someParam: anotherObject.variableA > 0)

        func innerMethod(param: Bool) {
            if param || variableD {
                for number in [0, 1, 2, 3] {
                    print(number)
                }
            }
        }

        innerMethod(param: result)
    }

}
