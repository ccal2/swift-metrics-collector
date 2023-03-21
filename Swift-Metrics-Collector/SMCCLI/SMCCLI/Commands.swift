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

    @Argument(help: "Path to the file to be parsed")
    var filePath: String

    func validate() throws {
        guard FileManager.default.fileExists(atPath: filePath) else {
            throw ValidationError("\(filePath) doesn't exist.")
        }

        guard FileManager.default.isReadableFile(atPath: filePath) else {
            throw ValidationError("<file-path> is not readable.")
        }
    }

    func run() {
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)

            let testingClass = MyTestingClass(fileContent: fileContent)
            testingClass.proccess()
        } catch {
            // TODO: handle error
        }
    }

}
