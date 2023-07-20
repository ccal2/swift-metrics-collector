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
    private(set) var types: Set<TypeNode> = []
    /// Variables declared in the root context
    private(set) var variables: Set<VariableNode> = []
    /// Methods declared in the root context
    private(set) var methods: Set<MethodNode> = []

    /// All types declared in the root context or nested in other types
    private(set) var allTypes: Set<TypeNode> = []

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

        generateTypes()
        generateOtherElements()
    }

    // MARK: - Private methods

    // MARK: Handle types

    private func generateTypes() {
        var contextsWaitingForSuperType: [TypeContext] = []

        var iterator = ContextBreadthIterator(root: rootContext)
        while let currentContext = iterator.next() {
            guard let typeContext = currentContext as? TypeContext else {
                continue
            }

            handleTypeContext(typeContext, contextsWaitingForSuperType: &contextsWaitingForSuperType)
        }

        handleRemainingContextsWaitingForSuperType(&contextsWaitingForSuperType)
    }

    private func handleTypeContext(_ context: TypeContext, contextsWaitingForSuperType: inout [TypeContext]) {
        var superTypeNode: TypeNode? = nil
        if context.firstInheritedType != nil {
            guard let superTypeNodeIndex = allTypes.firstIndex(where: { typeNode in
                typeNode.context.isSuperType(of: context)
            }) else {
                contextsWaitingForSuperType.append(context)
                return
            }

            superTypeNode = allTypes[superTypeNodeIndex]

            // If the current context was already in the `contextsWaitingForSuperType` list, remove it
            contextsWaitingForSuperType.removeAll { waitingContext in
                waitingContext === context
            }
        }

        let typeNode = TypeNode(parent: superTypeNode, context: context)
        allTypes.insert(typeNode)

        handlePossibleChildren(of: typeNode, contextsWaitingForSuperType: &contextsWaitingForSuperType)

        if superTypeNode == nil {
            types.insert(typeNode)
        }
    }

    private func handlePossibleChildren(of typeNode: TypeNode, contextsWaitingForSuperType: inout [TypeContext]) {
        var index = 0
        while index < contextsWaitingForSuperType.count  {
            guard typeNode.context.isSuperType(of: contextsWaitingForSuperType[index]) else {
                index += 1
                continue
            }

            let subTypeNode = TypeNode(parent: typeNode, context: contextsWaitingForSuperType[index])
            allTypes.insert(subTypeNode)

            contextsWaitingForSuperType.remove(at: index)
            // Don't increment the index because one element has been removed
        }
    }

    private func handleRemainingContextsWaitingForSuperType(_ contexts: inout [TypeContext]) {
        // If the super type hasn't been found after iterating over all contexts,
        // then it could be a protocol or some class defined outside of the scope.
        // In this case, create a node with no parent
        var index = 0
        while !contexts.isEmpty  {
            let hasSuperType = contexts.contains { otherContext in
                otherContext.isSuperType(of: contexts[index])
            }

            if hasSuperType {
                // If the super type of the current context is also waiting, then the current context will have to stay in the queue untill its super type is processed
                index += 1
            } else {
                let typeNode = TypeNode(parent: nil, context: contexts[index])
                allTypes.insert(typeNode)
                types.insert(typeNode)
                contexts.remove(at: index)

                handlePossibleChildren(of: typeNode, contextsWaitingForSuperType: &contexts)
                // Since the context array can be modified in handlePossibleChildren, we need to reset the index
                index = 0
            }
        }
    }

    // MARK: Handle other elements

    private func generateOtherElements() {
        handleGlobalContext(rootContext)
    }

    private func handleGlobalContext(_ context: Context) {
        for child in context.children {
            if let fileExtension = child as? FileContext {
                handleGlobalContext(fileExtension)
            } else if let variableContext = child as? VariableDeclarationContext {
                handleVariableContext(variableContext)
            } else if let methodContext = child as? MethodContext {
                handleMethodContext(methodContext)
            } else if let typeExtensionContext = child as? TypeExtensionContext {
                handleTypeExtensionContext(typeExtensionContext)
            }
        }
    }

    private func handleVariableContext(_ context: VariableDeclarationContext) {
        let variableNode = VariableNode(parent: nil, context: context)
        variables.insert(variableNode)
    }

    private func handleMethodContext(_ context: MethodContext) {
        let methodNode = MethodNode(parent: nil, context: context)
        methods.insert(methodNode)
    }

    private func handleTypeExtensionContext(_ context: TypeExtensionContext) {
        for type in allTypes {
            guard type.identifier == context.identifier else {
                continue
            }

            _ = TypeExtensionNode(parent: type, context: context)
            return
        }
    }

}
