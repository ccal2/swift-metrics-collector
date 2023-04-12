//
//  Tests.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser

public class MyTestingClass {

    // MARK: - Properties

    private let fileContent: String

    // MARK: - Initializers

    public init(fileContent: String) {
        self.fileContent = fileContent
    }

    // MARK: - Methods

    public func proccess() {
        let sourceFile = Parser.parse(source: fileContent)
//        dump(sourceFile)

        let globalContext = Context(parent: nil)
        let visitor = ContextTreeGeneratorVisitor(rootContext: globalContext)
        visitor.walk(sourceFile)
        print("--------------")

        let tree = ElementsTree(rootContext: globalContext)
        tree.generateTree()
        print("Type inheritance trees:")
        for root in tree.types {
            print(root.printableDescription())
        }
        print("--------------")
    }

}
