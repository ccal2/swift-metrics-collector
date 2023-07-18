class SuperClass {
    var variableA: Double

    init(a: Double) {
        self.variableA = a
    }

    func aMethod() -> String {
        return "a"
    }

    func returnClosure() -> (() -> Void) {
        { print("closure") }
    }

}