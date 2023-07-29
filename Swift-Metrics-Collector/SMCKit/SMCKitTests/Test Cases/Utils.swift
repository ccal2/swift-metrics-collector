//
//  Utils.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 19/07/23.
//

import XCTest
@testable import SMCKit

// MARK: - Constants

let inputsDirectoryPath = "\(UserSettings.projectPath)/SMCKit/SMCKitTests/Test Cases/Inputs"

// MARK: - Methods

func analyze(input: String) throws -> Report {
    let collector = MetricsCollector()
    try collector.analyze(path: "\(inputsDirectoryPath)/\(input)")
    return collector.createReport()
}

func getClass(from report: Report, withIdentifier classIdentifier: String) throws -> ReportItem {
    guard let classItem = report.classes[classIdentifier] else {
        throw NSError(domain: "SMCKitTests", code: 1, userInfo: [NSLocalizedDescriptionKey: "The report has no class with identifier \"\(classIdentifier)\""])
    }

    return classItem
}

func assertMetrics(for item: ReportItem, expectedValue: Metrics, file: StaticString = #file, line: UInt = #line) {
    assertNOC(for: item, expectedValue: expectedValue.numberOfChildren, file: file, line: line)
    assertDIT(for: item, expectedValue: expectedValue.depthOfInheritance, file: file, line: line)
    assertWMC(for: item, expectedValue: expectedValue.weightedMethodsPerClass, file: file, line: line)
    assertLCOM(for: item, expectedValue: expectedValue.lackOfCohesionInMethods, file: file, line: line)
    assertRFC(for: item, expectedValue: expectedValue.responseForAClass, file: file, line: line)
}

func assertNOC(for item: ReportItem, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    assertMetric("NOC", metricValue: item.metrics.numberOfChildren, expectedValue: expectedValue, file: file, line: line)
}

func assertDIT(for item: ReportItem, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    assertMetric("DIT", metricValue: item.metrics.depthOfInheritance, expectedValue: expectedValue, file: file, line: line)
}

func assertWMC(for item: ReportItem, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    assertMetric("WMC", metricValue: item.metrics.weightedMethodsPerClass, expectedValue: expectedValue, file: file, line: line)
}

func assertLCOM(for item: ReportItem, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    assertMetric("LCOM", metricValue: item.metrics.lackOfCohesionInMethods, expectedValue: expectedValue, file: file, line: line)
}

func assertRFC(for item: ReportItem, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    assertMetric("RFC", metricValue: item.metrics.responseForAClass, expectedValue: expectedValue, file: file, line: line)
}

private func assertMetric(_ metricSymbol: String, metricValue: Int, expectedValue: Int, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(metricValue, expectedValue, "Expected \(metricSymbol) to be \(expectedValue), but it was \(metricValue)", file: file, line: line)
}
