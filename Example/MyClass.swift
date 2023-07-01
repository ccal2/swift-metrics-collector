class MyClass: SuperClass {
    var variableB: Int
    var variableC: String

    init(b: Int, c: String, a: Double) {
        self.variableB = b
        self.variableC = c
        super.init(a: a)
    }
}