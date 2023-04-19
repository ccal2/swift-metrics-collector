//
//  TypeNode.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

class TypeNode: ContainerNode {

    // MARK: - Properties

    let context: TypeContext

    private(set) weak var parent: TypeNode?
    private(set) var children: [TypeNode] = []

    private(set) lazy var kind: TypeKind = {
        context.kind
    }()

    private(set) lazy var identifier: String = {
        context.fullIdentifier
    }()

    private(set) lazy var variables: [VariableNode] = {
        context.variableDeclarations.map { context in
            VariableNode(parent: self, context: context)
        }
    }()

    private(set) lazy var nonStaticVariables: [VariableNode] = {
        variables.filter { node in
            !node.isStatic
        }
    }()

    private(set) lazy var methods: [MethodNode]  = {
        context.methods.map { context in
            MethodNode(parent: self, context: context)
        }
    }()

    private(set) lazy var instanceMethods: [MethodNode]  = {
        methods.filter { node in
            !node.isStatic
        }
    }()

    private(set) lazy var depthOfInheritance: Int = {
        var depth = 0

        var node = self
        while let parent = node.parent {
            depth += 1
            node = parent
        }

        return depth
    }()

    // MARK: Computed properties

    var numberOfChildren: Int {
        children.count
    }

    /// Consider a Class C_1_ with n methods M_1_,M_2_,...,M_n_. Let {I_j_} = set of instance variables used by method M_i_.
    /// There are n such sets {l_1_},..., {I_n_}. Let P = {(l_i_,I_j_) | I_i_^ I_j_= 0} and Q =  {(l_i_,I_j_) | I_i_^ I_j_!= 0}. If all n sets {I_1_},...,{I_n_} are 0 then let P = 0).
    var lackOfCohesionInMethods: Int {
        let methodsCount = instanceMethods.count
        var disjointSets = 0
        var intersectingSets = 0

        guard methodsCount > 0 else {
            return 0
        }

        for i in 0 ..< methodsCount-1 {
            for j in i+1 ..< methodsCount {
                if instanceMethods[i].accessedInstanceVariables.isDisjoint(with: instanceMethods[j].accessedInstanceVariables) {
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
        self.parent = parent
        self.context = context
        super.init()

        parent?.children.append(self)
    }

    // MARK: - Methods

    func printableDescription(identationLevel: Int = 0) -> String {
        let prefix = Array(repeating: "\t", count: identationLevel).joined()

        let childrenDescription = children.map { child in
            child.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let variablesDescription = variables.map { variable in
            variable.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        let methodsDescription = methods.map { method in
            method.printableDescription(identationLevel: identationLevel + 1)
        }.joined(separator: ",\n")

        return """
        \(prefix)Type: {
        \(prefix)   identifier: \(identifier)
        \(prefix)   children: [
        \(childrenDescription)
        \(prefix)   ],
        \(prefix)   variables: [
        \(variablesDescription)
        \(prefix)   ],
        \(prefix)   methods: [
        \(methodsDescription)
        \(prefix)   ],
        \(prefix)   NOC: \(numberOfChildren),
        \(prefix)   DIT: \(depthOfInheritance),
        \(prefix)   LCOM: \(lackOfCohesionInMethods),
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
