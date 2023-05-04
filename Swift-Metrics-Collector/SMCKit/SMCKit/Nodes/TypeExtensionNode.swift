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

        parent.extensions.append(self)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        return """
        \(prefix)Extension: {
        \(prefix)   identifier: \(identifier)
        \(prefix)   variables: [
        \(variablesDescription)
        \(prefix)   ],
        \(prefix)   methods: [
        \(methodsDescription)
        \(prefix)   ]
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
