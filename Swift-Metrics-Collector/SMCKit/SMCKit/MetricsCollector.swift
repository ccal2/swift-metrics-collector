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

    private var _report: Report?
    private var report: Report {
        createReport()
    }

    // MARK: - Initializers

    public init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    // MARK: - Public methods

    public func analyze(path: String) throws {
        try process(path: path)
        tree.generateTree()
    }

    public func analyze(content: String) {
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
        let reportFileURL = fileURL(from: path, fileExtension: fileFormat.rawValue)

        try structuredReport.write(to: reportFileURL, atomically: true, encoding: .utf8)
    }

    public func saveGraph(at path: String) throws {
        let graph = createGraph()
        let reportFileURL = fileURL(from: path, fileExtension: "mmd")

        try graph.write(to: reportFileURL, atomically: true, encoding: .utf8)
    }

    // MARK: - Internal methods

    func createReport() -> Report {
        assert(tree.generatedTree, "The report can only be created after the tree has been generated")

        if let report = _report {
            return report
        }

        var classes: [String: ReportItem] = [:]

        for typeNode in tree.allTypes {
            if typeNode.kind == .class {
                classes[typeNode.identifier] = ReportItem(identifier: typeNode.identifier,
                                                          metrics: MetricsCalculator.calculateMetrics(for: typeNode))
            }
        }

        let report = Report(classes: classes)
        _report = report

        return report
    }

    func createGraph() -> String {
        var graph: String = "---\ntitle: Inheritance tree with metrics\n---\ngraph TD\n\tclassDef classNode text-align:left;\n\n"

        for typeNode in tree.allTypes {
            if typeNode.kind == .class {
                addTypeNode(for: typeNode, toGraph: &graph)
            }
        }

        return graph
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
        let filePaths = swiftFilePaths(at: path)

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

    private func swiftFilePaths(at path: String) -> [String] {
        let expandedPath = NSString(string: path).expandingTildeInPath
        let resourceKeys = Set<URLResourceKey>([.isRegularFileKey, .nameKey, .pathKey])

        guard let enumerator = FileManager.default.enumerator(at: URL(fileURLWithPath: expandedPath),
                                                              includingPropertiesForKeys: Array(resourceKeys),
                                                              options: [.skipsHiddenFiles, .skipsPackageDescendants]) else {
            return []
        }

        var swiftFilePaths: [String] = []
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

                swiftFilePaths.append(path)
            } catch {
                print(error, fileURL)
            }
        }

        return swiftFilePaths
    }

    /// Creates an `URL` based on the given path and file extension. If there already exists a file at that path then it tries to add "(1)" at the end of the path. If that already exists, it moves to 2 and so on...
    /// - Parameters:
    ///   - path: The path used to create the `URL` object.
    ///   - fileExtension: The file extension for the file at `path`.
    /// - Returns: An `URL` for the given path or a similar one with a counter added at the end of the file name, if a file with the same name already exists.
    private func fileURL(from path: String, fileExtension: String) -> URL {
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

    private func addTypeNode(for typeNode: TypeNode, toGraph graph: inout String) {
        graph.append("\t\(typeNode.identifier)(\"#nbsp;\(typeNode.identifier)#nbsp;")
        if let metrics = report.classes[typeNode.identifier]?.metrics {
            graph.append("<br><br>#nbsp;NOC = \(metrics.numberOfChildren)<br>#nbsp;DIT = \(metrics.depthOfInheritance)<br>#nbsp;WMC = \(metrics.weightedMethodsPerClass)<br>#nbsp;LCOM = \(metrics.lackOfCohesionInMethods)<br>#nbsp;RFC = \(metrics.responseForAClass)")
        }
        graph.append("\")\n")

        graph.append("\tclass \(typeNode.identifier) classNode\n")

        if let parent = typeNode.parent as? TypeNode {
            graph.append("\t\(parent.identifier)-->\(typeNode.identifier)\n")
        }

        graph.append("\n")
    }

}

// MARK: - ReportFileFormat

public extension MetricsCollector {

    enum ReportFileFormat: String {
        case csv
        case json
    }

}
