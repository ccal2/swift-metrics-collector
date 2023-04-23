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
