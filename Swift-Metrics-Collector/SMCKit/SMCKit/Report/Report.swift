//
//  Report.swift
//  SMCKit
//
//  Created by Carolina Lopes on 22/04/23.
//

struct Report: Codable {
    let classes: [String: ReportItem]
}

struct ReportItem: Codable {
    let identifier: String
    let metrics: Metrics
}

struct Metrics: Codable {
    let numberOfChildren: Int
    let depthOfInheritance: Int
    let weightedMethodsPerClass: Int
    let lackOfCohesionInMethods: Int
    let responseForAClass: Int
    let couplingBetweenObjectClasses: Int

    enum CodingKeys: String, CodingKey, CaseIterable {
        case numberOfChildren = "NOC"
        case depthOfInheritance = "DIT"
        case weightedMethodsPerClass = "WMC"
        case lackOfCohesionInMethods = "LCOM"
        case responseForAClass = "RFC"
        case couplingBetweenObjectClasses = "CBO"
    }
}
