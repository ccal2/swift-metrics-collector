//
//  TypeExtensionNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 03/05/23.
//

class TypeExtensionNode: ContainerNode<TypeExtensionContext> {

    // MARK: - Properties

    private(set) lazy var identifier: String = {
        context.identifier
    }()

    // MARK: - Initializers

    init(parent: TypeNode, context: TypeExtensionContext) {
        super.init(parent: parent, context: context)

        parent.extensions.insert(self)
    }

    // MARK: - Methods

    func printableDescription(indentationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: indentationLevel).joined()

        let variablesDescription = variables.map { variable in
            variable.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(indentationLevel: indentationLevel + 2)
        }.joined(separator: ",\n")

        return """
        \(prefix)Extension: {
        \(prefix)\tidentifier: \(identifier)
        \(prefix)\tvariables: [
        \(variablesDescription)
        \(prefix)\t],
        \(prefix)\tmethods: [
        \(methodsDescription)
        \(prefix)\t]
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension TypeExtensionNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
