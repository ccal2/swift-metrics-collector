//
//  TC_WMC_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 26/07/23.
//

import XCTest
@testable import SMCKit

fileprivate let input_folder = "WMC"

final class TC_WMC_Tests: XCTestCase {

    func test_TC_WMC_001() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-001.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 0)
    }

    func test_TC_WMC_002() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-002.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 1)
    }

    func test_TC_WMC_003() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-003.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 3)
    }

    func test_TC_WMC_004() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-004.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 5)
    }

    func test_TC_WMC_005() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-005.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 4)
    }

    func test_TC_WMC_006() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-006.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 5)
    }

    func test_TC_WMC_007() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-007.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertWMC(for: class2, expectedValue: 0)
    }

    func test_TC_WMC_008() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-008.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 5)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertWMC(for: class2, expectedValue: 0)
    }

    func test_TC_WMC_009() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-009.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 5)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertWMC(for: class2, expectedValue: 3)
    }

    func test_TC_WMC_010() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-010.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertWMC(for: class2, expectedValue: 3)
    }

    func test_TC_WMC_011() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-011/")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 4)
    }

    func test_TC_WMC_012() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-012/")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 5)
    }

    func test_TC_WMC_013() throws {
        let report = try analyze(input: "\(input_folder)/TC-WMC-013.swift")

        XCTAssertEqual(report.classes.count, 3)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertWMC(for: class1, expectedValue: 1)

        // Class1_1
        let class1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1")
        assertWMC(for: class1_1, expectedValue: 0)

        // Class1_1_1
        let class1_1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_1")
        assertWMC(for: class1_1_1, expectedValue: 3)
    }

}
