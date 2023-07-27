//
//  MetricsCalculatorTests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 13/07/23.
//

import XCTest
@testable import SMCKit

final class MetricsCalculatorTests: XCTestCase {

    func test_connectedComponents_oneComponent() throws {
        let vertices = ["A", "B", "C", "D", "E", "F"]
        let edges = [[1, 3],
                     [0, 2, 3],
                     [1, 4, 5],
                     [0, 1],
                     [2],
                     [2]]

        let connectedComponents = MetricsCalculator.connectedComponents(vertices: vertices, edges: edges)

        XCTAssertEqual(connectedComponents, 1)
    }

    func test_connectedComponents_twoComponent() throws {
        let vertices = ["A", "B", "C", "D", "E", "F"]
        let edges = [[1, 3],
                     [0, 2, 3],
                     [1, 4],
                     [0, 1],
                     [2],
                     []]

        let connectedComponents = MetricsCalculator.connectedComponents(vertices: vertices, edges: edges)

        XCTAssertEqual(connectedComponents, 2)
    }

    func test_connectedComponents_fourComponent() throws {
        let vertices = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
        let edges = [[1, 2],
                     [0, 2],
                     [0, 1],
                     [5],
                     [8],
                     [3],
                     [8],
                     [],
                     [4, 6]]

        let connectedComponents = MetricsCalculator.connectedComponents(vertices: vertices, edges: edges)

        XCTAssertEqual(connectedComponents, 4)
    }

}
