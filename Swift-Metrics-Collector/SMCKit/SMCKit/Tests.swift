//
//  Tests.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser

public class MyTestingClass {

    // MARK: - Properties

    private let globalContext = Context(parent: nil)
    private lazy var visitor = ContextTreeGeneratorVisitor(rootContext: globalContext)
    private lazy var tree = ElementsTree(rootContext: globalContext)

    // MARK: - Initializers

    public init() { }

    // MARK: - Methods

    public func proccessFile(at filePath: String) throws {
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        proccess(content: fileContent)
    }

    public func proccess(content: String) {
        let sourceFile = Parser.parse(source: content)
        visitor.walk(sourceFile)

        tree.generateTree()
        print("Type inheritance trees:")
        for root in tree.types {
            print(root.printableDescription())
        }
        print("--------------")
    }

}
