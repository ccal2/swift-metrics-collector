//
//  TC_RFC_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 27/07/23.
//

import XCTest
@testable import SMCKit

fileprivate let input_folder = "RFC"

final class TC_RFC_Tests: XCTestCase {

    func test_TC_RFC_001() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-001.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 0)
    }

    func test_TC_RFC_002() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-002.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 0)
    }

    func test_TC_RFC_003() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-003.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 3)
    }

    func test_TC_RFC_004() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-004.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 5)
    }

    func test_TC_RFC_005() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-005.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 4)
    }

    func test_TC_RFC_006() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-006.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 3)
    }

    func test_TC_RFC_007() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-007.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 0)
    }

    func test_TC_RFC_008() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-008.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 3)
    }

    func test_TC_RFC_009() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-009.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 6)
    }

    func test_TC_RFC_010() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-010.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 3)
    }

    func test_TC_RFC_011() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-011/")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 4)
    }

    func test_TC_RFC_012() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-012/")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 5)
    }

    func test_TC_RFC_013() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-013.swift")

        XCTAssertEqual(report.classes.count, 3)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 1)

        // Class1_1
        let class1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1")
        assertRFC(for: class1_1, expectedValue: 0)

        // Class1_1_1
        let class1_1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_1")
        assertRFC(for: class1_1_1, expectedValue: 2)
    }

    func test_TC_RFC_014() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-014.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 4)
    }

    func test_TC_RFC_015() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-015.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 4)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 10)
    }

    func test_TC_RFC_016() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-016.swift")

        XCTAssertEqual(report.classes.count, 1)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 9)
    }

    func test_TC_RFC_017() throws {
        let report = try analyze(input: "\(input_folder)/TC-RFC-017.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertRFC(for: class1, expectedValue: 3)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertRFC(for: class2, expectedValue: 4)
    }

}
