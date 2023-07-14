//
//  Class2.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 04/07/23.
//

class Class2: Class1, Protocol1 {

    var variableB: Double
    var variableC: String

    init(b: Double, c: String, a: Double) {
        self.variableB = b
        self.variableC = c
        super.init(a: a)
    }

}
