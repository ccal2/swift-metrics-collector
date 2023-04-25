//
//  MetricsCollector.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser

public class MetricsCollector {

    // MARK: - Properties

    private let fileManager: FileManager
    private let globalContext = Context(parent: nil)
    private lazy var visitor = ContextTreeGeneratorVisitor(rootContext: globalContext)
    private lazy var tree = ElementsTree(rootContext: globalContext)

    // MARK: - Initializers

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    public func analyse(path: String) throws {
        try process(path: path)
        tree.generateTree()
    }

    public func analyse(content: String) {
        process(content: content)
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

    private func process(path: String) throws {
        if path.last == "/" {
            try processDirectory(at: path)
        } else {
            try processFile(at: path)
        }
    }

    private func processDirectory(at path: String) throws {
        let filePaths = siwftFilePaths(at: path)

        for filePath in filePaths {
            try processFile(at: filePath)
        }
    }

    private func processFile(at filePath: String) throws {
        let expandedPath = NSString(string: filePath).expandingTildeInPath
        let fileURL = URL(fileURLWithPath: expandedPath)

        guard let fileName = fileURL.deletingPathExtension().pathComponents.last else {
            throw NSError(domain: "", code: 0)
        }

        visitor.newFileContext(named: fileName)

        let fileContent = try String(contentsOfFile: expandedPath, encoding: .utf8)
        process(content: fileContent)
    }

    private func process(content: String) {
        let sourceFile = Parser.parse(source: content)
        visitor.walk(sourceFile)
    }

    private func siwftFilePaths(at path: String) -> [String] {
        let expandedPath = NSString(string: path).expandingTildeInPath
        let resourceKeys = Set<URLResourceKey>([.isRegularFileKey, .nameKey, .pathKey])

        guard let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: expandedPath),
                                                              includingPropertiesForKeys: Array(resourceKeys),
                                                              options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
            return []
        }

        var siwftFilePaths: [String] = []
        for case let fileURL as URL in enumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys: resourceKeys)

                guard fileAttributes.isRegularFile == true else {
                    continue
                }

                guard let path = fileAttributes.path else {
                    continue
                }

                guard URL(fileURLWithPath: path).pathExtension.lowercased() == "swift" else {
                    continue
                }

                siwftFilePaths.append(path)
            } catch {
                print(error, fileURL)
            }
        }

        return siwftFilePaths
    }

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
