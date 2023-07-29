//
//  MethodParameterNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/04/23.
//

class MethodParameterNode: Node<MethodParameterContext> {

    // MARK: - Properties

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
        super.init(parent: parent, context: context)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        return """
        \(prefix)Parameter: {
        \(prefix)\tlabel: \(label ?? "nil"),
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\ttypeIdentifier: \(typeIdentifier)
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
