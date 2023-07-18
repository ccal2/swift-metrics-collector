//
//  Report.swift
//  SMCKit
//
//  Created by Carolina Lopes on 22/04/23.
//

struct Report: Codable {
    let classes: [ReportItem]
}

struct ReportItem: Codable {
    let identifier: String
    let metrics: Metrics
}

struct Metrics: Codable {
    let weightedMethodsPerClass: Int
    let numberOfChildren: Int
    let depthOfInheritance: Int
    let lackOfCohesionInMethods: Int
    let responseForAClass: Int

    enum CodingKeys: String, CodingKey, CaseIterable {
        case weightedMethodsPerClass = "Weighted Methods Per Class (WMC)"
        case numberOfChildren = "Number of Children (NOC)"
        case depthOfInheritance = "Depth of Inheritance (DIT)"
        case lackOfCohesionInMethods = "Lack of Cohesion in Methods (LCOM)"
        case responseForAClass = "Response For a Class (RFC)"
    }
}
