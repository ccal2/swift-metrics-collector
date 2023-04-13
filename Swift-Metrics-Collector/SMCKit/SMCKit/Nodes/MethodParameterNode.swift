//
//  MethodParameterNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodParameterNode {

    // MARK: - Properties

    let context: MethodParameterContext

    private(set) weak var parent: MethodNode?

    private(set) lazy var label: String? = {
        context.firstName
    }()

    private(set) lazy var identifier: String = {
        if let secondName = context.secondName {
            return secondName
        }

        guard let firstName = context.firstName else {
            fatalError("Missing identifier in parameter")
        }

        return firstName
    }()

    private(set) lazy var typeIdentifier: String = {
        guard let type = context.typeIdentifier else {
            fatalError("Missing type identifier in parameter")
        }

        return type
    }()

    // MARK: - Initializers

    init(parent: MethodNode, context: MethodParameterContext) {
        self.parent = parent
        self.context = context
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        return """
        \(prefix)Parameter: {
        \(prefix)   label: \(label ?? "nil"),
        \(prefix)   identifier: \(identifier),
        \(prefix)   typeIdentifier: \(typeIdentifier)
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension MethodParameterNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
