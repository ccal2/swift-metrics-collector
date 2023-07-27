//
//  TC_DIT_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 24/07/23.
//

import XCTest
@testable import SMCKit

final class TC_DIT_Tests: XCTestCase {

    func test_TC_DIT_001() throws {
        let report = try analyze(input: "TC-DIT-001.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertDIT(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertDIT(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertDIT(for: class3, expectedValue: 2)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertDIT(for: class4, expectedValue: 3)
    }

    func test_TC_DIT_002() throws {
        let report = try analyze(input: "TC-DIT-002.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertDIT(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertDIT(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertDIT(for: class3, expectedValue: 2)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertDIT(for: class4, expectedValue: 3)
    }

    func test_TC_DIT_003() throws {
        let report = try analyze(input: "TC-DIT-003.swift")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertDIT(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertDIT(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertDIT(for: class3, expectedValue: 2)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertDIT(for: class4, expectedValue: 3)
    }

    func test_TC_DIT_004() throws {
        let report = try analyze(input: "TC-DIT-004/")

        XCTAssertEqual(report.classes.count, 4)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertDIT(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertDIT(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertDIT(for: class3, expectedValue: 2)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertDIT(for: class4, expectedValue: 3)
    }

    func test_TC_DIT_005() throws {
        let report = try analyze(input: "TC-DIT-005.swift")

        XCTAssertEqual(report.classes.count, 7)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertDIT(for: class1, expectedValue: 0)

        // Class1_1
        let class1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1")
        assertDIT(for: class1_1, expectedValue: 0)

        // Class1_1_1
        let class1_1_1 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_1")
        assertDIT(for: class1_1_1, expectedValue: 0)

        // Class1_1_2
        let class1_1_2 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_2")
        assertDIT(for: class1_1_2, expectedValue: 1)

        // Class1_1_3
        let class1_1_3 = try getClass(from: report, withIdentifier: "Class1.Class1_1.Class1_1_3")
        assertDIT(for: class1_1_3, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertDIT(for: class2, expectedValue: 0)

        // Class2_1
        let class2_1 = try getClass(from: report, withIdentifier: "Class2.Class2_1")
        assertDIT(for: class2_1, expectedValue: 1)
    }

}
