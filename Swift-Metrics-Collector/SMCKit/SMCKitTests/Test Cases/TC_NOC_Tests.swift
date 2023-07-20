//
//  TC_NOC_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 19/07/23.
//

import XCTest
@testable import SMCKit

final class TC_NOC_Tests: XCTestCase {

    func test_TC_NOC_001() throws {
        let report = try analyse(input: "TC-NOC-001.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertNOC(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertNOC(for: class4, expectedValue: 0)
    }

    func test_TC_NOC_002() throws {
        let report = try analyse(input: "TC-NOC-002.swift")

        XCTAssertEqual(report.classes.count, 5)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 3)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertNOC(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertNOC(for: class4, expectedValue: 0)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertNOC(for: class5, expectedValue: 0)
    }

    func test_TC_NOC_003() throws {
        let report = try analyse(input: "TC-NOC-003.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertNOC(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertNOC(for: class4, expectedValue: 0)
    }

    func test_TC_NOC_004() throws {
        let report = try analyse(input: "TC-NOC-004.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertNOC(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertNOC(for: class4, expectedValue: 0)
    }

    func test_TC_NOC_005() throws {
        let report = try analyse(input: "TC-NOC-005/")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertNOC(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertNOC(for: class4, expectedValue: 0)
    }

    func test_TC_NOC_006() throws {
        let report = try analyse(input: "TC-NOC-006.swift")

        XCTAssertEqual(report.classes.count, 7)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertNOC(for: class1, expectedValue: 0)

        // Class1_1
        let class1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1")
        assertNOC(for: class1_1, expectedValue: 0)

        // Class1_1_1
        let class1_1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_1")
        assertNOC(for: class1_1_1, expectedValue: 3)

        // Class1_1_2
        let class1_1_2 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_2")
        assertNOC(for: class1_1_2, expectedValue: 0)

        // Class1_1_3
        let class1_1_3 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_3")
        assertNOC(for: class1_1_3, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertNOC(for: class2, expectedValue: 0)

        // Class2_1
        let class2_1 = try getClass(from: report, withIdentifier: "Class2.Class2_1")
        assertNOC(for: class2_1, expectedValue: 0)
    }

}
