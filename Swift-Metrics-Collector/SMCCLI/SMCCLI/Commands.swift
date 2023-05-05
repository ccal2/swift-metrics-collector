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

    static private let defaultReportFileName: String = "swift-metrics-collector-report"
    static private let defaultReportFileDirectory: String = "~/Downloads/"

    // MARK: - Arguments, flags and options

    @Argument(help: "Path of the file to be analized")
    var filePath: String

    @Flag(help: "Report file format")
    var reportFormat: ReportFormat = .json

    @Option(help: "Path where to save the report. If it ends with a \"/\", the report will be saved in the given directory with the default name (\(Self.defaultReportFileName))")
    var reportFilePath: String? = nil

    // MARK: - Methods

    func validate() throws {
        let expandedPath = NSString(string: filePath).expandingTildeInPath
        guard FileManager.default.fileExists(atPath: expandedPath) else {
            throw ValidationError("<file-path> \(filePath) doesn't exist.")
        }

        guard FileManager.default.isReadableFile(atPath: expandedPath) else {
            throw ValidationError("<file-path> \(filePath) is not readable.")
        }
    }

    func run() {
        let collector = MetricsCollector()

        do {
            try collector.analyse(path: filePath)
        } catch {
            // TODO: handle error
            print(error)
        }

        do {
            try collector.saveReport(at: reportPath(),
                                     fileFormat: reportFormat.reportFileFormat)
        } catch {
            // TODO: handle error
            print(error)
        }
    }

    private func reportPath() -> String {
        guard let reportFilePath else {
            return "\(Self.defaultReportFileDirectory)\(Self.defaultReportFileName)"
        }

        guard reportFilePath.last != "/" else {
            return "\(reportFilePath)\(Self.defaultReportFileName)"
        }

        return reportFilePath
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
