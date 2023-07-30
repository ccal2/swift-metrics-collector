//
//  TypeContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class TypeContext: Context {

    // MARK: - Properties

    let identifier: String
    let firstInheritedType: String?
    let kind: TypeKind

    private(set) lazy var fullIdentifier: String = {
        allPossibleIdentifiers.last ?? identifier
    }()

    private(set) lazy var allPossibleIdentifiers: [String] = {
        var identifiers: [String] = [identifier]
        var prefix = ""
        var context: Context = self

        while let parent = context.parent {
            if let identifiedContext = parent as? TypeContext {
                prefix = identifiedContext.identifier + "." + prefix
                identifiers.append(prefix + identifier)
            }
            context = parent
        }

        return identifiers
    }()

    // MARK: - Initializers

    init(parent: Context, identifier: String, firstInheritedType: String?, kind: TypeKind) {
        self.identifier = identifier
        self.firstInheritedType = firstInheritedType
        self.kind = kind
        super.init(parent: parent)
    }

    // MARK: - Methods

    func isSuperType(of context: TypeContext) -> Bool {
        guard let firstInheritedType = context.firstInheritedType else {
            return false
        }

        return allPossibleIdentifiers.contains(firstInheritedType)
    }

}
