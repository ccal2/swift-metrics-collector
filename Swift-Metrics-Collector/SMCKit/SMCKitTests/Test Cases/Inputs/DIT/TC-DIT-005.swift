//
//  TC-DIT-005.swift
//  SMCKit
//
//  Created by Carolina Lopes on 24/07/23.
//

class Class1 {
    class Class1_1 {
        class Class1_1_1 { }
        class Class1_1_2: Class1_1_1 { }
        class Class1_1_3: Class1.Class1_1.Class1_1_1 { }
    }
}
class Class2 {
    class Class2_1: Class1.Class1_1.Class1_1_1 { }
}
