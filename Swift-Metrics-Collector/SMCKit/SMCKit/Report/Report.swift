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
    let weightedMethodsPerClass: Int
    let numberOfChildren: Int
    let depthOfInheritance: Int
    let lackOfCohesionInMethods: Int
    let responseForAClass: Int

    enum CodingKeys: String, CodingKey, CaseIterable {
        case weightedMethodsPerClass = "WMC"
        case numberOfChildren = "NOC"
        case depthOfInheritance = "DIT"
        case lackOfCohesionInMethods = "LCOM"
        case responseForAClass = "RFC"
    }
}
