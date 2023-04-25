//
//  MetricsCollector.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser

public class MetricsCollector {

    // MARK: - Properties

    private let globalContext = Context(parent: nil)
    private lazy var visitor = ContextTreeGeneratorVisitor(rootContext: globalContext)
    private lazy var tree = ElementsTree(rootContext: globalContext)
    private let fileManager: FileManager

    // MARK: - Initializers

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    public func proccessFile(at filePath: String) throws {
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        proccess(content: fileContent)
    }

    public func proccess(content: String) {
        let sourceFile = Parser.parse(source: content)
        visitor.walk(sourceFile)

        tree.generateTree()
    }

    public func saveReport(at path: String, fileFormat: ReportFileFormat) throws {
        let reportStructurer: ReportStructurer
        switch fileFormat {
        case .csv:
            reportStructurer = CSVReportStructurer()
        case .json:
            reportStructurer = JSONReportStructurer()
        }

        let structuredReport = try reportStructurer.structure(report: createReport())
        let reportFileURL = reportFileURL(from: path, fileExtension: fileFormat.rawValue)

        try structuredReport.write(to: reportFileURL, atomically: true, encoding: .utf8)
    }

    // MARK: - Private methods

    private func reportFileURL(from path: String, fileExtension: String) -> URL {
        let expandedPath = NSString(string: path).expandingTildeInPath
        var url = URL(fileURLWithPath: expandedPath)

        if url.pathExtension.lowercased() != fileExtension.lowercased() {
            url.appendPathExtension(fileExtension)
        }

        var counter = 0
        let originalFileURL = url
        let pathExtension = originalFileURL.pathExtension
        while fileManager.fileExists(atPath: url.path) {
            counter += 1

            let incrementedPath = "\(originalFileURL.deletingPathExtension().path)(\(counter))"
            url = URL(fileURLWithPath: incrementedPath).appendingPathExtension(pathExtension)
        }

        return url
    }

    private func createReport() -> Report {
        var classes: [ReportItem] = []

        for typeNode in tree.allTypes {
            if typeNode.kind == .class {
                classes.append(ReportItem(identifier: typeNode.identifier,
                                          metrics: Metrics(numberOfChildren: typeNode.numberOfChildren,
                                                           depthOfInheritance: typeNode.depthOfInheritance,
                                                           lackOfCohesionInMethods: typeNode.lackOfCohesionInMethods)))
            }
        }

        return Report(classes: classes)
    }

}

// MARK: - ReportFileFormat

public extension MetricsCollector {

    enum ReportFileFormat: String {
        case csv
        case json
    }

}
