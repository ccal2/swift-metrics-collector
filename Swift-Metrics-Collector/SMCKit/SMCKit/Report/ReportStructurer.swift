//
//  ReportStructurer.swift
//  SMCKit
//
//  Created by Carolina Lopes on 22/04/23.
//

protocol ReportStructurer {
    func structure(report: Report) throws -> String
}

class JSONReportStructurer: ReportStructurer {

    func structure(report: Report) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(report)
        return String(data: jsonData, encoding: .utf8)!
    }

}

class CSVReportStructurer: ReportStructurer {

    func structure(report: Report) throws -> String {
        let metricsHeader = Metrics.CodingKeys.allCases.map { element in
            element.rawValue
        }.joined(separator: ",")

        var csvString = "Class,\(metricsHeader)\n"

        for item in report.classes.values {
            csvString.append("\(item.identifier),\(item.metrics.weightedMethodsPerClass),\(item.metrics.numberOfChildren),\(item.metrics.depthOfInheritance),\(item.metrics.lackOfCohesionInMethods),\(item.metrics.responseForAClass)\n")
        }

        return csvString
    }

}
