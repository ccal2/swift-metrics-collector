//
//  MetricsCalculator.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/07/23.
//

struct MetricsCalculator {

    static func calculateMetrics(for typeNode: TypeNode) -> Metrics {
        Metrics(numberOfChildren: calculateNOC(for: typeNode),
                depthOfInheritance: calculateDIT(for: typeNode),
                weightedMethodsPerClass: calculateWMC(for: typeNode),
                lackOfCohesionInMethods: calculateLCOM_HM(for: typeNode),
                responseForAClass: calculateRFC(for: typeNode),
                couplingBetweenObjectClasses: calculateCBO(for: typeNode))
    }

    static func calculateWMC(for typeNode: TypeNode) -> Int {
        typeNode.methodsIncludingExtensions.count
    }

    static func calculateNOC(for typeNode: TypeNode) -> Int {
        typeNode.children.count
    }

    static func calculateDIT(for typeNode: TypeNode) -> Int {
        guard let parent = typeNode.parent as? TypeNode else {
            return 0
        }

        return calculateDIT(for: parent) + 1
    }

//    /// Consider a Class C with n methods M_1_,M_2_,...,M_n_. Let {I_i_} = set of instance variables used by method M_i_.
//    /// Let P = {(I_i_,I_j_) | I_i_ ∩ I_j_ = ∅} and Q = {(I_i_,I_j_) | I_i_ ∩ I_j_ != ∅. If all n sets {I_1_},...,{I_n_} are 0 then let P = ∅.
//    /// LCOM(C) =  |P| - |Q|, if |P| > |Q|
//    ///          0, otherwise
//    static func calculateLCOM(for typeNode: TypeNode) -> Int {
//        let methods = typeNode.instanceMethodsIncludingExtensions
//        let methodsCount = methods.count
//        var disjointSets = 0
//        var intersectingSets = 0
//
//        guard methodsCount > 0 else {
//            return 0
//        }
//
//        for i in 0 ..< methodsCount-1 {
//            for j in i+1 ..< methodsCount {
//                if methods[i].accessedInstanceVariables.isDisjoint(with: methods[j].accessedInstanceVariables) {
//                    disjointSets += 1
//                } else {
//                    intersectingSets += 1
//                }
//            }
//        }
//
//        return disjointSets > intersectingSets ? disjointSets - intersectingSets : 0
//    }

    /// Hitz and Montazeri LCOM
    /// Consider a Class X
    /// M_X_ is the set of methods of X
    /// I_X_ is the set of instance variables of X
    /// G_X_(V,E) is an undirected graph where:
    ///     - V = M_X_
    ///     - E = { <m,n> ∈ V x V | ∃ i ∈ I_X :  (m accesses i) ∧ (n accesses i)}
    /// LCOM(X) = number of connected components of G_X_
    static func calculateLCOM_HM(for typeNode: TypeNode) -> Int {
        let methods = typeNode.instanceMethodsIncludingExtensions
        let methodsCount = methods.count

        guard methodsCount > 0 else {
            return 0
        }

        // connectionsByMethod represents the edges in the graph
        // connectionsByMethod[i] is the list of connections of methods[i]
        // The connections are represented by the connecting method index in the methods array
        var connectionsByMethod: [[Int]] = Array(repeating: [], count: methods.count)

        for i in 0 ..< methodsCount-1 {
            for j in i+1 ..< methodsCount {
                if !methods[i].accessedInstanceVariables.isDisjoint(with: methods[j].accessedInstanceVariables) {
                    connectionsByMethod[i].append(j)
                    connectionsByMethod[j].append(i)
                }
            }
        }

        return connectedComponents(vertices: methods, edges: connectionsByMethod)
    }

    static func connectedComponents(vertices: Array<Any>, edges: [[Int]]) -> Int {
        var visited = Array(repeating: false, count: vertices.count)

        func dfs(vertexIndex: Int) {
            visited[vertexIndex] = true

            let adjacentVertices = edges[vertexIndex]
            for adjacentIndex in 0 ..< adjacentVertices.count where visited[adjacentVertices[adjacentIndex]] == false {
                dfs(vertexIndex: adjacentVertices[adjacentIndex])
            }
        }

        var componentCount = 0
        for vertexIndex in 0 ..< vertices.count where visited[vertexIndex] == false {
            dfs(vertexIndex: vertexIndex)
            componentCount += 1
        }

        return componentCount
    }

    static func calculateRFC(for typeNode: TypeNode) -> Int {
        var methodCalls: Set<String> = []

        for method in typeNode.allInstanceMethods {
            methodCalls.insert(method.identifier)
            methodCalls.formUnion(method.methodCalls)
        }

        return methodCalls.count
    }

    static func calculateCBO(for typeNode: TypeNode) -> Int {
        return typeNode.typeCouplings.count
    }

}
