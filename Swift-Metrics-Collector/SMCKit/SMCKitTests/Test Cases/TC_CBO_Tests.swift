//
//  TC_CBO_Tests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 30/07/23.
//

import XCTest
@testable import SMCKit

fileprivate let input_folder = "CBO"

final class TC_CBO_Tests: XCTestCase {

    func test_TC_CBO_001() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-001.swift")

        XCTAssertEqual(report.classes.count, 2)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 0)
    }

    func test_TC_CBO_002() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-002.swift")

        XCTAssertEqual(report.classes.count, 3)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)
    }

    func test_TC_CBO_003() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-003.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_004() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-004.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 3)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_005() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-005.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_006() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-006.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_007() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-007.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 3)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_008() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-008.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_009() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-009.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_010() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-010.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 0)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 0)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 2)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_011() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-011.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_012() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-012.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

    func test_TC_CBO_013() throws {
        let report = try analyze(input: "\(input_folder)/TC-CBO-013.swift")

        XCTAssertEqual(report.classes.count, 6)

        // Class1
        let class1 = try getClass(from: report, withIdentifier: "Class1")
        assertCBO(for: class1, expectedValue: 1)

        // Class2
        let class2 = try getClass(from: report, withIdentifier: "Class2")
        assertCBO(for: class2, expectedValue: 1)

        // Class3
        let class3 = try getClass(from: report, withIdentifier: "Class3")
        assertCBO(for: class3, expectedValue: 0)

        // Class4
        let class4 = try getClass(from: report, withIdentifier: "Class4")
        assertCBO(for: class4, expectedValue: 4)

        // Class5
        let class5 = try getClass(from: report, withIdentifier: "Class5")
        assertCBO(for: class5, expectedValue: 1)

        // Class6
        let class6 = try getClass(from: report, withIdentifier: "Class6")
        assertCBO(for: class6, expectedValue: 1)
    }

}
