class MyClass: SuperClass {
    var variableB: Int
    var variableC: String

    init(b: Int, c: String, a: Double) {
        self.variableB = b
        self.variableC = c
        super.init(a: a)
    }

    func foo() {
        print(someMethod(someParam: variableD))

        let object = SuperClass(a: 1.0)
        object.aMethod().uppercased()
        object.aMethod().uppercased().count
        print(object.aMethod().lowercased())

        let object2 = SuperClass.init(a: 2.0)
        _ = object2.aMethod()

        print(object.variableA)
        _ = object.variableA

        object.returnClosure()()
    }

}