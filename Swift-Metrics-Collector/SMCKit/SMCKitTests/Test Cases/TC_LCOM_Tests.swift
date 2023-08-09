//
//  TC_LCOM_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 08/08/23.
//

import XCTest
@testable import SMCKit

fileprivate let input_folder = "LCOM"

final class TC_LCOM_Tests: XCTestCase {

    func test_TC_LCOM_001() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-001.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 3)
    }

    func test_TC_LCOM_002() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-002.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 2)
    }

    func test_TC_LCOM_003() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-003.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 2)
    }

    func test_TC_LCOM_004() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-004.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 2)
    }

    func test_TC_LCOM_005() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-005.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 2)
    }

    func test_TC_LCOM_006() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-006.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 1)
    }

    func test_TC_LCOM_007() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-007.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 1)
    }

    func test_TC_LCOM_008() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-008.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 1)
    }

    func test_TC_LCOM_009() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-009/")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertLCOM(for: class2, expectedValue: 1)
    }

    func test_TC_LCOM_010() throws {
        let report = try analyze(input: "\(input_folder)/TC-LCOM-010.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertLCOM(for: class1, expectedValue: 0)
    }

}
