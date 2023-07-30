//
//  MetricsCollector.swift
//  SMCKit
//
//  Created by Carolina Lopes on 20/03/23.
//

import SwiftParser

public class MetricsCollector {

    // MARK: - Properties

    private var outputPath: String
    private let fileManager: FileManager
    private let globalContext = Context(parent: nil)
    private lazy var visitor = ContextTreeGeneratorVisitor(rootContext: globalContext)
    private lazy var tree = ElementsTree(rootContext: globalContext)

    private var _report: Report?
    private var report: Report {
        createReport()
    }

    private var createdOutputDirectory: Bool = false

    // MARK: - Initializers

    public init(outputPath: String, fileManager: FileManager = .default) {
        self.outputPath = (outputPath as NSString).expandingTildeInPath
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

    public func saveReport(withFileName fileName: String, andFormat fileFormat: ReportFileFormat) throws {
        try createOutputDirectory()

        let reportStructurer: ReportStructurer
        switch fileFormat {
        case .csv:
            reportStructurer = CSVReportStructurer()
        case .json:
            reportStructurer = JSONReportStructurer()
        }

        let structuredReport = try reportStructurer.structure(report: createReport())

        try structuredReport.write(to: outputFileURL(withName: fileName, andExtension: fileFormat.rawValue),
                                   atomically: true,
                                   encoding: .utf8)
    }

    public func saveInheritanceTree(withFileName fileName: String, showMetrics: Bool) throws {
        try createOutputDirectory()

        let graph = createGraph(withMetrics: showMetrics)

        try graph.write(to: outputFileURL(withName: fileName, andExtension: "mmd"),
                        atomically: true,
                        encoding:.utf8)
    }

    // MARK: - Internal methods

    func createReport() -> Report {
        assert(tree.generatedTree, "The report can only be created after the tree has been generated")

        if let _report {
            return _report
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

    func createGraph(withMetrics: Bool) -> String {
        var graph: String = "---\ntitle: Inheritance tree"

        if withMetrics {
            graph.append(" with metrics")
        }

        graph.append("\n---\ngraph TD\n\tclassDef classNode text-align:left;\n\n")

        for typeNode in tree.allTypes {
            if typeNode.kind == .class {
                addTypeNode(for: typeNode, toGraph: &graph, withMetrics: withMetrics)
            }
        }

        return graph
    }

    // MARK: - Private methods

    private func process(path: String) throws {
        // Try to process path as a file
        // If it fails because the path is actually a directory, process it as a directory
        do {
            try processFile(at: path)
        } catch let error as NSError {
            // Expected error thrown by `String(contentsOfFile:encoding:)` if the file path is a directory
            guard error.domain == NSCocoaErrorDomain && error.underlyingErrors.contains(where: { underlyingError in
                (underlyingError as NSError).domain == NSPOSIXErrorDomain && (underlyingError as NSError).code == 21
            }) else {
                throw error
            }

            try processDirectory(at: path)
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
        let fileContent = try String(contentsOfFile: expandedPath, encoding: .utf8)

        let fileURL = URL(fileURLWithPath: expandedPath)
        guard let fileName = fileURL.deletingPathExtension().pathComponents.last else {
            throw NSError(domain: "", code: 0)
        }

        visitor.newFileContext(named: fileName)
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


    /// Tries to create a directory at `outputPath`. If there is already a file or directory at that path then it tries to add "(1)" at the end of the path. If that already exists, it moves to 2 and so on.
    /// If it is needed to add the number differentiator at the end of the output path, this method updates the `outputPath` property accordingly.
    ///
    /// E.g.:
    /// `outputPath` = "~/Downloads/swift-metrics-collector-output/"
    /// 1. Try to create a directory named "swift-metrics-collector-output" at "~/Downloads/".
    /// 2. If it already exists, try to create a directory named "swift-metrics-collector-output(1)" at "~/Downloads/".
    /// 3. If it already exists, try to create a directory named "swift-metrics-collector-output(2)" at "~/Downloads/".
    /// 4. And so on until it's able to create a file with a non-existing name.
    private func createOutputDirectory() throws {
        guard !createdOutputDirectory else {
            return
        }

        var counter = 0
        let originalPath = outputPath
        while fileManager.fileExists(atPath: outputPath) {
            counter += 1

            let incrementedPath = "\(originalPath)(\(counter))"
            outputPath = incrementedPath
        }

        try fileManager.createDirectory(atPath: outputPath, withIntermediateDirectories: true)

        createdOutputDirectory = true
    }

    private func outputFileURL(withName fileName: String, andExtension fileExtension: String) -> URL {
        var url = URL(fileURLWithPath: "\(outputPath)/\(fileName)")

        if url.pathExtension.lowercased() != fileExtension.lowercased() {
            url.appendPathExtension(fileExtension)
        }

        return url
    }

    private func addTypeNode(for typeNode: TypeNode, toGraph graph: inout String, withMetrics: Bool) {
        graph.append("\t\(typeNode.identifier)(\"#nbsp;\(typeNode.identifier)#nbsp;")
        if let metrics = report.classes[typeNode.identifier]?.metrics, withMetrics {
            graph.append("<br><br>#nbsp;NOC = \(metrics.numberOfChildren)<br>#nbsp;DIT = \(metrics.depthOfInheritance)<br>#nbsp;WMC = \(metrics.weightedMethodsPerClass)<br>#nbsp;LCOM = \(metrics.lackOfCohesionInMethods)<br>#nbsp;RFC = \(metrics.responseForAClass)")
        }
        graph.append("\")\n")

        graph.append("\tclass \(typeNode.identifier) classNode\n")

        if let parent = typeNode.parent as? TypeNode {
            graph.append("\t\(parent.identifier)--->\(typeNode.identifier)\n")
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
