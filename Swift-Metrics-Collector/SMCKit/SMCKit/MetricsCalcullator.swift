//
//  MetricsCalcullator.swift
//  SMCKit
//
//  Created by Carolina Lopes on 10/07/23.
//

struct MetricsCalcullator {

    static func calculateMetrics(for typeNode: TypeNode) -> Metrics {
        Metrics(weightedMethodsPerClass: calculateWMC(for: typeNode),
                numberOfChildren: calculateNOC(for: typeNode),
                depthOfInheritance: calculateDIT(for: typeNode),
                lackOfCohesionInMethods: calculateLCOM(for: typeNode))
    }

    static func calculateWMC(for typeNode: TypeNode) -> Int {
        typeNode.methods.count
    }

    static func calculateNOC(for typeNode: TypeNode) -> Int {
        typeNode.children.count
    }

//    static func calculateDIT(for typeNode: TypeNode) -> Int {
//        var depth = 0
//
//        var node: any NodeObject = typeNode
//        while let parent = node.parent {
//            depth += 1
//            node = parent
//        }
//
//        return depth
//    }

    static func calculateDIT(for typeNode: TypeNode) -> Int {
        guard let parent = typeNode.parent as? TypeNode else {
            return 0
        }

        return calculateDIT(for: parent) + 1
    }

    /// Consider a Class C with n methods M_1_,M_2_,...,M_n_. Let {I_i_} = set of instance variables used by method M_i_.
    /// Let P = {(l_i_,I_j_) | I_i_^ I_j_= 0} and Q =  {(l_i_,I_j_) | I_i_^ I_j_!= 0}. If all n sets {I_1_},...,{I_n_} are 0 then let P = 0.
    /// LCOM =  |P| - |Q|, if |P| > |Q|
    ///        0, otherwise
    static func calculateLCOM(for typeNode: TypeNode) -> Int {
        let methods = typeNode.instanceMethodsIncludingExtensions
        let methodsCount = methods.count
        var disjointSets = 0
        var intersectingSets = 0

        guard methodsCount > 0 else {
            return 0
        }

        for i in 0 ..< methodsCount-1 {
            for j in i+1 ..< methodsCount {
                if methods[i].accessedInstanceVariables.isDisjoint(with: methods[j].accessedInstanceVariables) {
                    disjointSets += 1
                } else {
                    intersectingSets += 1
                }
            }
        }

        return disjointSets > intersectingSets ? disjointSets - intersectingSets : 0
    }

//    static func calculateLCOM_HS(for typeNode: TypeNode) -> Double {
//        let methods = typeNode.instanceMethodsIncludingExtensions
//        let m = Double(methods.count)
//        let variables = typeNode.instanceVariablesIncludingExtensions
//        let n = Double(variables.count)
//
//        guard n > 0 else {
//            return (0 - m) / (1 - m)
//        }
//
//        var aggregatedMethodCountByVariable: Double = 0.0
//        for method in methods {
//            for variable in variables {
//                if method.accessedInstanceVariables.contains(variable) {
//                    aggregatedMethodCountByVariable += 1.0
//                }
//            }
//        }
//
//        return (aggregatedMethodCountByVariable/n - m)/(1 - m)
//    }

}
