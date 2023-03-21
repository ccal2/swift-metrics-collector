//
//  TypeContext.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class ClassContext: TypeContext { }


class TypeContext: Context {

    let identifier: String
    let firstInheritedType: String?

    lazy var fullIdentifier: String = {
        // Since allPossibleIdentifiers starts with one element, it will never be empty
        allPossibleIdentifiers.last!
    }()

    lazy var allPossibleIdentifiers: [String] = {
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

    init(parent: Context, identifier: String, firstInheritedType: String?) {
        self.identifier = identifier
        self.firstInheritedType = firstInheritedType
        super.init(parent: parent)
    }

}
