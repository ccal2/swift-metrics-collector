//
//  MetricsCollectorTests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 01/07/23.
//

import XCTest

@testable import SMCKit

fileprivate let inputsDirectoryPath = "~/Documents/Faculdade/2022.2 e 2023.1/TCC/swift-metrics-collector/Swift-Metrics-Collector/SMCKit/SMCKitTests/MetricsCollector/Inputs"

final class MetricsCollectorTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testClassInheritanceInSingleFile() throws {
        let collector = MetricsCollector()

        try collector.analyse(path: "\(inputsDirectoryPath)/SingleFile.swift")
        let report = collector.createReport()

        XCTAssertEqual(report.classes.count, 9)

        // Class1
        let class1 = report.classes.first { item in
            item.identifier == "Class1"
        }
        XCTAssertNotNil(class1)
        XCTAssertEqual(class1?.metrics.numberOfChildren, 3)
        XCTAssertEqual(class1?.metrics.depthOfInheritance, 0)
        XCTAssertEqual(class1?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class1?.metrics.responseForAClass, 0)

        // Class2
        let class2 = report.classes.first { item in
            item.identifier == "Class2"
        }
        XCTAssertNotNil(class2)
        XCTAssertEqual(class2?.metrics.numberOfChildren, 1)
        XCTAssertEqual(class2?.metrics.depthOfInheritance, 0)
        XCTAssertEqual(class2?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class2?.metrics.responseForAClass, 0)

        // Class3
        let class3 = report.classes.first { item in
            item.identifier == "Class3"
        }
        XCTAssertNotNil(class3)
        XCTAssertEqual(class3?.metrics.numberOfChildren, 1)
        XCTAssertEqual(class3?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class3?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class3?.metrics.responseForAClass, 0)

        // Class3_1
        let class3_1 = report.classes.first { item in
            item.identifier == "Class3.Class3_1"
        }
        XCTAssertNotNil(class3_1)
        XCTAssertEqual(class3_1?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class3_1?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class3_1?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class3_1?.metrics.responseForAClass, 0)

        // Class3_1_1
        let class3_1_1 = report.classes.first { item in
            item.identifier == "Class3.Class3_1.Class3_1_1"
        }
        XCTAssertNotNil(class3_1_1)
        XCTAssertEqual(class3_1_1?.metrics.numberOfChildren, 1)
        XCTAssertEqual(class3_1_1?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class3_1_1?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class3_1_1?.metrics.responseForAClass, 0)

        // Class4
        let class4 = report.classes.first { item in
            item.identifier == "Class4"
        }
        XCTAssertNotNil(class4)
        XCTAssertEqual(class4?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class4?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class4?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class4?.metrics.responseForAClass, 0)

        // Class5
        let class5 = report.classes.first { item in
            item.identifier == "Class5"
        }
        XCTAssertNotNil(class5)
        XCTAssertEqual(class5?.metrics.numberOfChildren, 1)
        XCTAssertEqual(class5?.metrics.depthOfInheritance, 2)
        XCTAssertEqual(class5?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class5?.metrics.responseForAClass, 0)

        // Class6
        let class6 = report.classes.first { item in
            item.identifier == "Class6"
        }
        XCTAssertNotNil(class6)
        XCTAssertEqual(class6?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class6?.metrics.depthOfInheritance, 3)
        XCTAssertEqual(class6?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class6?.metrics.responseForAClass, 0)

        // Class7
        let class7 = report.classes.first { item in
            item.identifier == "Class7"
        }
        XCTAssertNotNil(class7)
        XCTAssertEqual(class7?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class7?.metrics.depthOfInheritance, 2)
        XCTAssertEqual(class7?.metrics.lackOfCohesionInMethods, 0)
        XCTAssertEqual(class7?.metrics.responseForAClass, 0)
    }

    func testMetricsCollectionInProject() throws {
        let collector = MetricsCollector()

        try collector.analyse(path: "\(inputsDirectoryPath)/Project/")
        let report = collector.createReport()

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = report.classes.first { item in
            item.identifier == "Class1"
        }
        XCTAssertNotNil(class1)
        XCTAssertEqual(class1?.metrics.numberOfChildren, 2)
        XCTAssertEqual(class1?.metrics.depthOfInheritance, 0)
        XCTAssertEqual(class1?.metrics.lackOfCohesionInMethods, 3)
        XCTAssertEqual(class1?.metrics.responseForAClass, 5)

        // Class2
        let class2 = report.classes.first { item in
            item.identifier == "Class2"
        }
        XCTAssertNotNil(class2)
        XCTAssertEqual(class2?.metrics.numberOfChildren, 1)
        XCTAssertEqual(class2?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class2?.metrics.lackOfCohesionInMethods, 1)
        XCTAssertEqual(class2?.metrics.responseForAClass, 6)

        // Class3
        let class3 = report.classes.first { item in
            item.identifier == "Class3"
        }
        XCTAssertNotNil(class3)
        XCTAssertEqual(class3?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class3?.metrics.depthOfInheritance, 2)
        XCTAssertEqual(class3?.metrics.lackOfCohesionInMethods, 1)
        XCTAssertEqual(class3?.metrics.responseForAClass, 9)

        // Class4
        let class4 = report.classes.first { item in
            item.identifier == "Class4"
        }
        XCTAssertNotNil(class4)
        XCTAssertEqual(class4?.metrics.numberOfChildren, 0)
        XCTAssertEqual(class4?.metrics.depthOfInheritance, 1)
        XCTAssertEqual(class4?.metrics.lackOfCohesionInMethods, 2)
        XCTAssertEqual(class4?.metrics.responseForAClass, 10)
    }

}
