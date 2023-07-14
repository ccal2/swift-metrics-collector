//
//  Class2+Extension.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 04/07/23.
//

extension Class2 {

    var variableD: Bool {
        variableB > 10
    }

    func someMethod(someParam: Bool) -> Bool {
        return someParam || variableD
    }

}
