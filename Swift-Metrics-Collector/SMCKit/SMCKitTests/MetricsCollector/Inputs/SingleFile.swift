//
//  SingleFile.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 01/07/23.
//

class Class1 { }
class Class2 { }

class Class3: Class1 {
    class Class3_1: Class2 {
        class Class3_1_1: Class1 { }
    }
}

class Class4: Class1 { }

class Class5: Class3 { }

class Class6: Class5 { }

class Class7: Class3.Class3_1.Class3_1_1 { }
