//
//  Tests.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser
import SwiftSyntax

public class MyTestingClass {

    private let fileContent: String

    public init(fileContent: String) {
        self.fileContent = fileContent
    }

    public func proccess() {
        let sourceFile = Parser.parse(source: fileContent)
//        dump(sourceFile)

        let visitor = MyVisitor(viewMode: .sourceAccurate)
        visitor.walk(sourceFile)
        print("--------------")

        let treeRoots = createClassInheritanceTrees(from: visitor.globalContext)
        print("Class inheritance trees:")
        for root in treeRoots {
            root.printWithChildren(prefix: "\t")
        }
        print("--------------")
    }

    func createClassInheritanceTrees(from rootContext: Context) -> [ClassInheritanceNode] {
        var contextsWaitingForSuperClass: [ClassContext] = []
        var allClassNodes: [ClassInheritanceNode] = []
        var treeRoots: [ClassInheritanceNode] = []

        var iterator = ContextBreadthIterator(root: rootContext)
        while let currentContext = iterator.next() {
            guard let classContext = currentContext as? ClassContext else {
                continue
            }

            var superCalssNode: ClassInheritanceNode? = nil
            if let firstInheritedType = classContext.firstInheritedType {
                guard let superClassNodeIndex = allClassNodes.firstIndex(where: { classNode in
                    classNode.context.allPossibleIdentifiers.contains(firstInheritedType)
                }) else {
                    contextsWaitingForSuperClass.append(classContext)
                    continue
                }

                superCalssNode = allClassNodes[superClassNodeIndex]
            }

            let classNode = ClassInheritanceNode(parent: superCalssNode, context: classContext)
            allClassNodes.append(classNode)

            var index = 0
            while index < contextsWaitingForSuperClass.count  {
                guard let firstInheritedType = contextsWaitingForSuperClass[index].firstInheritedType,
                      classContext.allPossibleIdentifiers.contains(firstInheritedType) else {
                    index += 1
                    continue
                }

                let subClassNode = ClassInheritanceNode(parent: classNode, context: contextsWaitingForSuperClass[index])
                allClassNodes.append(subClassNode)

                contextsWaitingForSuperClass.remove(at: index)
                // Don't increment the index because one element has been removed
            }

            if superCalssNode == nil {
                treeRoots.append(classNode)
            }
        }

        return treeRoots
    }

}

class MyVisitor: SyntaxVisitor {

    let globalContext = Context(parent: nil)
    lazy var currentContext: Context = globalContext

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
//        print("class declaration:")
//        dump(node)
//        print("------------")

        let identifier = node.identifier.text
        print("visiting class: '\(identifier)'")
        let firstInheritedType = node.inheritanceClause?.inheritedTypeCollection.first?.typeName.as(SimpleTypeIdentifierSyntax.self)?.name.text
        print("\tfirstInheritedType: '\(firstInheritedType ?? "nil")'")

        let classContext = ClassContext(parent: currentContext, identifier: identifier, firstInheritedType: firstInheritedType)
        currentContext = classContext

        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        guard let parentContext = currentContext.parent else {
            fatalError("currentContext.parent can't be nil right after visiting a class")
        }
        currentContext = parentContext
    }

}


