//
//  Commands.swift
//  SMCCLI
//
//  Created by Carolina Lopes on 20/03/23.
//

import ArgumentParser
import Foundation
import SMCKit

@main
struct SwiftMetricsCollector: ParsableCommand {

    // MARK: - Constants

    static private let defaultOutputPath: String = "~/Downloads/"
    static private let defaultOutputDirectoryName: String = "swift-metrics-collector-output"
    static private let defaultReportFileName: String = "report"
    static private let defaultInheritanceTreeFileName: String = "inheritance-tree"
    static private let defaultInheritanceTreeWithMetricsFileName: String = "inheritance-tree-with-metrics"

    // MARK: - Arguments, flags and options

    @Argument(help: "Path of the file or directory to be analyzed")
    var path: String

    @Flag(help: "Report file format")
    var reportFormat: ReportFormat = .csv

    @Option(help: "Path where to save the tool output (report file)")
    var outputDirectoryPath: String = Self.defaultOutputPath

    // MARK: - Other properties

    private var outputDirectory: String {
        "\(outputDirectoryPath)\(Self.defaultOutputDirectoryName)/"
    }

    // MARK: - Methods

    func validate() throws {
        let expandedPath = NSString(string: path).expandingTildeInPath
        guard FileManager.default.fileExists(atPath: expandedPath) else {
            throw ValidationError("<path> \(path) doesn't exist.")
        }

        guard FileManager.default.isReadableFile(atPath: expandedPath) else {
            throw ValidationError("<path> \(path) is not readable.")
        }

        guard outputDirectoryPath.last == "/" else {
            throw ValidationError("<output-directory-path> \(outputDirectoryPath) doesn't end with \"/\".")
        }
    }

    func run() {
        let startingTime = Date()
        print("starting: \(startingTime)")

        defer {
            let finishingTime = Date()
            print("finished: \(finishingTime)")
            print("elapsed time: \(finishingTime.timeIntervalSince(startingTime))")
        }

        let collector = MetricsCollector(outputPath: outputDirectory)

        do {
            try collector.analyze(path: path)
        } catch {
            // TODO: handle error
            print(error)
            return
        }

        do {
            try collector.saveReport(withFileName: Self.defaultReportFileName,
                                     andFormat: reportFormat.reportFileFormat)
            try collector.saveInheritanceTree(withFileName: Self.defaultInheritanceTreeFileName,
                                              showMetrics: false)
            try collector.saveInheritanceTree(withFileName: Self.defaultInheritanceTreeWithMetricsFileName,
                                              showMetrics: true)
        } catch {
            // TODO: handle error
            print(error)
            return
        }
    }

}

// MARK: - ReportFormat

extension SwiftMetricsCollector {

    enum ReportFormat: EnumerableFlag {
        case csv
        case json

        /// Direct mapping for `MyTestingClass.ReportFileFormat`
        var reportFileFormat: MetricsCollector.ReportFileFormat {
            switch self {
            case .csv:
                return .csv
            case .json:
                return .json
            }
        }
    }

}
