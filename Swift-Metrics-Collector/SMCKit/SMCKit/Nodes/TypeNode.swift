//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class TypeNode: ContainerNode<TypeContext> {

    // MARK: - Properties

    var extensions: Set<TypeExtensionNode> = []

    private(set) var children: Set<TypeNode> = []

    private(set) lazy var kind: TypeKind = {
        context.kind
    }()

    private(set) lazy var identifier: String = {
        context.fullIdentifier
    }()

    private(set) lazy var allVariables: Set<VariableNode> = {
        var allVariables = variables

        var node: any NodeObject = self
        while let parent = node.parent as? TypeNode {
            node = parent
            allVariables.formUnion(parent.allVariables)
        }

        extensions.forEach { node in
            allVariables.formUnion(node.variables)
        }

        return allVariables
    }()

    private(set) lazy var allNonStaticVariables: Set<VariableNode> = {
        allVariables.filter { node in
            !node.isStatic
        }
    }()

    private(set) lazy var methodsIncludingExtensions: Set<MethodNode> = {
        var allMethods = methods

        extensions.forEach { node in
            allMethods.formUnion(node.methods)
        }

        return allMethods
    }()

    private(set) lazy var instanceMethods: Set<MethodNode>  = {
        methods.filter { node in
            !node.isStatic
        }
    }()

    private(set) lazy var instanceMethodsIncludingExtensions: [MethodNode]  = {
        methodsIncludingExtensions.filter { node in
            !node.isStatic
        }
    }()

    private(set) lazy var depthOfInheritance: Int = {
        var depth = 0

        var node: any NodeObject = self
        while let parent = node.parent {
            depth += 1
            node = parent
        }

        return depth
    }()

    private(set) lazy var weightedMethodsPerClass: Int = {
        methods.count
    }()

    // MARK: Computed properties

    var numberOfChildren: Int {
        children.count
    }

    /// Consider a Class C_1_ with n methods M_1_,M_2_,...,M_n_. Let {I_j_} = set of instance variables used by method M_i_.
    /// There are n such sets {l_1_},..., {I_n_}. Let P = {(l_i_,I_j_) | I_i_^ I_j_= 0} and Q =  {(l_i_,I_j_) | I_i_^ I_j_!= 0}. If all n sets {I_1_},...,{I_n_} are 0 then let P = 0).
    /// LCOM =  |P| - |Q|, if |P| > |Q|
    ///        0, otherwise
    var lackOfCohesionInMethods: Int {
        let methodsCount = instanceMethodsIncludingExtensions.count
        var disjointSets = 0
        var intersectingSets = 0

        guard methodsCount > 0 else {
            return 0
        }

        for i in 0 ..< methodsCount-1 {
            for j in i+1 ..< methodsCount {
                if instanceMethodsIncludingExtensions[i].accessedInstanceVariables.isDisjoint(with: instanceMethodsIncludingExtensions[j].accessedInstanceVariables) {
                    disjointSets += 1
                } else {
                    intersectingSets += 1
                }
            }
        }

        return disjointSets > intersectingSets ? disjointSets - intersectingSets : 0
    }

    // MARK: - Initializers

    init(parent: TypeNode?, context: TypeContext) {
        super.init(parent: parent, context: context)

        parent?.children.insert(self)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let extensionsDescription = extensions.map { `extension` in
            `extension`.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        let childrenDescription = children.map { child in
            child.printableDescription(identationLevel: identationLevel + 2)
        }.joined(separator: ",\n")

        return """
        \(prefix)Type: {
        \(prefix)\tidentifier: \(identifier),
        \(prefix)\tvariables: [
        \(variablesDescription)
        \(prefix)\t],
        \(prefix)\tmethods: [
        \(methodsDescription)
        \(prefix)\t],
        \(prefix)\textensions: [
        \(extensionsDescription)
        \(prefix)\t],
        \(prefix)\tNOC: \(numberOfChildren),
        \(prefix)\tDIT: \(depthOfInheritance),
        \(prefix)\tLCOM: \(lackOfCohesionInMethods),
        \(prefix)\tchildren: [
        \(childrenDescription)
        \(prefix)\t]
        \(prefix)}
        """
    }

}

// MARK: - CustomStringConvertible

extension TypeNode: CustomStringConvertible {

    var description: String {
        printableDescription()
    }

}
