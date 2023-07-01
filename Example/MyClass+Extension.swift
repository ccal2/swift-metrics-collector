extension MyClass {
    var variableD: Bool {
        false
    }

    func someMethod(someParam: Bool) -> Bool {
        return someParam || variableD
    }
}
