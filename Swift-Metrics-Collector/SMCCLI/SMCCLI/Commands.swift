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

    static private let defaultReportFileName: String = "report"
    static private let defaultOutputDirectory: String = "~/Downloads/swift-metrics-collector/"

    // MARK: - Arguments, flags and options

    @Argument(help: "Path of the file to be analized")
    var filePath: String

    @Flag(help: "Report file format")
    var reportFormat: ReportFormat = .json

    @Option(help: "Path where to save the tool output (report file)")
    var outputDirectoryPath: String = Self.defaultOutputDirectory

    // MARK: - Other properties

    private var reportPath: String {
        "\(outputDirectoryPath)\(Self.defaultReportFileName)"
    }

    // MARK: - Methods

    func validate() throws {
        let expandedPath = NSString(string: filePath).expandingTildeInPath
        guard FileManager.default.fileExists(atPath: expandedPath) else {
            throw ValidationError("<file-path> \(filePath) doesn't exist.")
        }

        guard FileManager.default.isReadableFile(atPath: expandedPath) else {
            throw ValidationError("<file-path> \(filePath) is not readable.")
        }

        guard outputDirectoryPath.last == "/" else {
            throw ValidationError("<output-directory-path> \(outputDirectoryPath) doesn't end with \"/\".")
        }
    }

    func run() {
        let startingTime = Date()
        print("starting: \(startingTime)")

        let collector = MetricsCollector()

        do {
            try collector.analyze(path: filePath)
        } catch {
            // TODO: handle error
            print(error)
        }

        do {
            try collector.saveReport(at: reportPath,
                                     fileFormat: reportFormat.reportFileFormat)
        } catch {
            // TODO: handle error
            print(error)
        }

        let finisingTime = Date()
        print("finished: \(finisingTime)")
        print("elapsed time: \(finisingTime.timeIntervalSince(startingTime))")
    }

}

// MARK: - ReportFormat

extension SwiftMetricsCollector {

    enum ReportFormat: EnumerableFlag {
        case csv
        case json

        /// Direct maping for `MyTestingClass.ReportFileFormat`
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
