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
    /// Identifiers that might indicate a coupling for a type
    private(set) var possibleCouplings: [TypeNode: Set<String>] = [:]

    /// All types declared in the root context or nested in other types
    private(set) var allTypes: Set<TypeNode> = []

    private(set) var generatedTree: Bool = false

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
        generateTypeCouplings()
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
                typeNode.isSuperType(of: context)
            }) else {
                contextsWaitingForSuperType.append(context)
                return
            }

            superTypeNode = allTypes[superTypeNodeIndex]
        }

        let typeNode = TypeNode(parent: superTypeNode, context: context)
        possibleCouplings[typeNode] = context.possibleTypeCouplings
        allTypes.insert(typeNode)
        if superTypeNode == nil {
            types.insert(typeNode)
        }

        _ = handlePossibleChildren(of: typeNode, contextsWaitingForSuperType: &contextsWaitingForSuperType)
    }

    private func handlePossibleChildren(of typeNode: TypeNode, contextsWaitingForSuperType: inout [TypeContext]) -> [Int] {
        var removedIndexes: [Int] = []
        var originalIndexes = Array(0 ..< contextsWaitingForSuperType.count)

        var index = 0
        while index < contextsWaitingForSuperType.count {
            guard typeNode.isSuperType(of: contextsWaitingForSuperType[index]) else {
                index += 1
                continue
            }

            let subTypeNode = TypeNode(parent: typeNode, context: contextsWaitingForSuperType[index])
            possibleCouplings[subTypeNode] = contextsWaitingForSuperType[index].possibleTypeCouplings
            allTypes.insert(subTypeNode)

            contextsWaitingForSuperType.remove(at: index)
            removedIndexes.append(originalIndex(of: index, remainingOriginalIndexes: &originalIndexes, removedIndexes: removedIndexes))

            let otherRemovedIndexes = handlePossibleChildren(of: subTypeNode, contextsWaitingForSuperType: &contextsWaitingForSuperType)
            let updatedRemovedIndexes = updatedRemovedIndexes(otherRemovedIndexes, previouslyRemovedIndexes: removedIndexes)
            removedIndexes.append(contentsOf: updatedRemovedIndexes)

            updateIndex(&index, removedIndexes: updatedRemovedIndexes)
        }

        return removedIndexes
    }

    private func handleRemainingContextsWaitingForSuperType(_ contexts: inout [TypeContext]) {
        var removedIndexes: [Int] = []
        var originalIndexes = Array(0 ..< contexts.count)

        var index = 0
        while index < contexts.count  {
            let superTypeIsWaiting = contexts.contains { otherContext in
                otherContext.isSuperType(of: contexts[index])
            }

            // If the super type of the current context is also waiting, then the current
            // context will have to stay in the queue until its super type is processed
            guard !superTypeIsWaiting else {
                index += 1
                continue
            }

            // If the super type hasn't been found after iterating over all contexts,
            // then it could be a protocol or some class defined outside of the scope.
            // In this case, create a node with no parent
            let typeNode = TypeNode(parent: nil, context: contexts[index])
            possibleCouplings[typeNode] = contexts[index].possibleTypeCouplings
            allTypes.insert(typeNode)
            types.insert(typeNode)
            contexts.remove(at: index)
            removedIndexes.append(originalIndex(of: index, remainingOriginalIndexes: &originalIndexes, removedIndexes: removedIndexes))

            let otherRemovedIndexes = handlePossibleChildren(of: typeNode, contextsWaitingForSuperType: &contexts)
            let updatedRemovedIndexes = updatedRemovedIndexes(otherRemovedIndexes, previouslyRemovedIndexes: removedIndexes)
            removedIndexes.append(contentsOf: updatedRemovedIndexes)

            updateIndex(&index, removedIndexes: updatedRemovedIndexes)
        }

        // All contexts are expected to be handled at this stage
        assert(contexts.isEmpty)
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
            if possibleCouplings[type] == nil {
                possibleCouplings[type] = []
            }
            possibleCouplings[type]?.formUnion(context.possibleTypeCouplings)
            return
        }
    }

    // MARK: Handle type couplings

    // TODO: Try to find a better way of collecting this information
    // Needs to e executed after `generateOtherElements` to take into account the extensions
    private func generateTypeCouplings() {
        for (typeNode, possibleTypeCouplings) in possibleCouplings {
            for possibleCoupling in possibleTypeCouplings {
                for otherType in allTypes where otherType != typeNode {
                    if otherType.allPossibleIdentifiers.contains(possibleCoupling) {
                        saveCouplingBetween(typeNode, and: otherType)
                        break
                    }
                }
            }
        }
    }

    private func saveCouplingBetween(_ firstType: TypeNode, and secondType: TypeNode) {
        let coupling = TypeCoupling(types: (firstType, secondType))

        // Save coupling for both types
        firstType.typeCouplings.insert(coupling)
        secondType.typeCouplings.insert(coupling)
    }

    // MARK: Helpers for relative index handling

    /// Calculate the original index value for a relative index in an array where some values have been previously removed.
    ///
    /// An example:
    /// 1. Consider the following array: ["A", "B", "C", "D", "E"].
    /// 2. If we remove the values from indexes 0 and 3 from this array, the remaining list will be: ["B", "C", "E"].
    /// 3. Now, if we want to find out the original index value for the element "E", for example, we can call this function like so: `originalIndex(of: 2, remainingOriginalIndexes: &originalIndexes, removedIndexes: [0, 3])`, where `originalIndexes = [0, 1, 2, 3, 4]`. The return will be `4`.
    ///
    /// - Parameters:
    ///   - relativeIndex: The relative index that we want to find the original value.
    ///   - remainingOriginalIndexes: An array with the original indexes, but only the ones that haven't been processed as removed yet. This function will update this list as the `removedIndexes` array is processed.
    ///   - removedIndexes: An array indicating the value of the previously removed indexes from the array.
    /// - Returns: The original index value of the given `relativeIndex`.
    private func originalIndex(of relativeIndex: Int, remainingOriginalIndexes: inout [Int], removedIndexes: [Int]) -> Int {
        var index = 0
        while index < remainingOriginalIndexes.count {
            if removedIndexes.contains(remainingOriginalIndexes[index]) {
                remainingOriginalIndexes.remove(at: index)
            } else {
                index += 1
            }
        }

        assert(relativeIndex < remainingOriginalIndexes.count)
        return remainingOriginalIndexes[relativeIndex]
    }

    /// Map each index of a recently removed value of an array into its original index, taking into account the values that had been removed previously.
    ///
    /// An example:
    /// 1. Consider the following array: ["A", "B", "C", "D", "E"].
    /// 2. If we remove the values from indexes 0 and 3 from this array, the remaining list will be: ["B", "C", "E"].
    /// 3. Now, if we use this remaining list to remove the values from indexes 0 and 2, we'll have: ["C"].
    /// 4. Going back to the original array defined in step 1, if we want to find out the original indexes for the removed values in step 3, we can call this function like so: `updatedRemovedIndexes([0, 2], previouslyRemovedIndexes: [0,3])`. The return will be [1, 4].
    /// 5. Now, if we want to indicate all the indexes from removed values of the original array, we can combine the `recentlyRemovedIndexes` with the function return: `[0, 3] + [1, 4] = [0, 3, 1, 4]`.
    ///
    /// - Parameters:
    ///   - recentlyRemovedIndexes: The relative indexes of recently removed values.
    ///   - previouslyRemovedIndexes: The original indexes of the previously removed values.
    /// - Returns: The original values of the indexes in `recentlyRemovedIndexes`.
    private func updatedRemovedIndexes(_ recentlyRemovedIndexes: [Int], previouslyRemovedIndexes: [Int]) -> [Int] {
        var updatedIndexes: [Int] = []

        for otherIndex in recentlyRemovedIndexes {
            var updatedIndex = otherIndex

            // TODO: Test this more:
            for index in previouslyRemovedIndexes where index <= updatedIndex {
                updatedIndex += 1
            }

            updatedIndexes.append(updatedIndex)
        }

        return updatedIndexes
    }

    /// Update the index value of an array, if necessary, taking into account the removed values in the indexes indicated in `removedIndexes`.
    /// - Parameters:
    ///   - index: The index to be updated.
    ///   - removedIndexes: The list of indexes from the array that had its values removed.
    private func updateIndex(_ index: inout Int, removedIndexes: [Int]) {
        var newIndex = index

        for removedIndex in removedIndexes where removedIndex < index {
            newIndex -= 1
        }

        index = newIndex < 0 ? 0 : newIndex
    }

}
