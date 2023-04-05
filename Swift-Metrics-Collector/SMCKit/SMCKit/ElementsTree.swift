//
//  ElementsTree.swift
//  SMCKit
//
//  Created by Carolina Lopes on 04/04/23.
//

class ElementsTree {

    // MARK: - Properties

    let rootContext: Context

    /// Types declared in the root context
    private(set)var types: [TypeNode] = []
    /// Variables declared in the root context
    private(set)var variables: [VariableNode] = []
    /// Methods declared in the root context
//     private(set) var methods: [MethodNode] = []

    /// All types declared in the root context or nested in other types
    private(set) var allTypes: [TypeNode] = []

    private var generatedTree: Bool = false

    // MARK: - Initializers

    init(rootContext: Context) {
        self.rootContext = rootContext
    }

    // MARK: - Methods

    func generateTree() {
        guard !generatedTree else {
            print("The tree is already created")
            return
        }
        generatedTree = true

        var contextsWaitingForSuperType: [TypeContext] = []

        var iterator = ContextBreadthIterator(root: rootContext)
        while let currentContext = iterator.next() {
            if let typeContext = currentContext as? TypeContext {
                handleTypeContext(typeContext, contextsWaitingForSuperType: &contextsWaitingForSuperType)
            }
        }
    }

    private func handleTypeContext(_ context: TypeContext, contextsWaitingForSuperType: inout [TypeContext]) {
        var superTypeNode: TypeNode? = nil
        if let firstInheritedType = context.firstInheritedType {
            guard let superTypeNodeIndex = allTypes.firstIndex(where: { typeNode in
                typeNode.context.allPossibleIdentifiers.contains(firstInheritedType)
            }) else {
                contextsWaitingForSuperType.append(context)
                return
            }

            superTypeNode = allTypes[superTypeNodeIndex]
        }

        let typeNode = TypeNode(parent: superTypeNode, context: context)
        allTypes.append(typeNode)

        var index = 0
        while index < contextsWaitingForSuperType.count  {
            guard let firstInheritedType = contextsWaitingForSuperType[index].firstInheritedType,
                  context.allPossibleIdentifiers.contains(firstInheritedType) else {
                index += 1
                continue
            }

            let subTypeNode = TypeNode(parent: typeNode, context: contextsWaitingForSuperType[index])
            allTypes.append(subTypeNode)

            contextsWaitingForSuperType.remove(at: index)
            // Don't increment the index because one element has been removed
        }

        if superTypeNode == nil {
            types.append(typeNode)
        }
    }

}
