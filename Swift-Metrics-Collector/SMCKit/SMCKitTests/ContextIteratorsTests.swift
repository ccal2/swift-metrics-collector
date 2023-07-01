//
//  ContextIteratorsTests.swift
//  SMCKitTests
//
//  Created by Carolina Lopes on 20/03/23.
//

import XCTest
@testable import SMCKit

final class ContextIteratorsTests: XCTestCase {

    var global: Context!
    var class1: TypeContext!
    var class1_1: TypeContext!
    var class1_2: TypeContext!
    var class2: TypeContext!
    var class3: TypeContext!
    var class3_1: TypeContext!
    var class4: TypeContext!
    var class5: TypeContext!

    override func setUpWithError() throws {
        global = Context(parent: nil)
        class1 = TypeContext(parent: global, identifier: "Class1", firstInheritedType: nil, kind: .class)
        class1_1 = TypeContext(parent: class1, identifier: "Class1_1", firstInheritedType: "Class1_2", kind: .class)
        class1_2 = TypeContext(parent: class1, identifier: "Class1_2", firstInheritedType: nil, kind: .class)
        class2 = TypeContext(parent: global, identifier: "Class2", firstInheritedType: "Class1_2", kind: .class)
        class3 = TypeContext(parent: global, identifier: "Class3", firstInheritedType: "Class1", kind: .class)
        class3_1 = TypeContext(parent: class3, identifier: "Class3_1", firstInheritedType: nil, kind: .class)
        class4 = TypeContext(parent: global, identifier: "Class4", firstInheritedType: "Class3", kind: .class)
        class5 = TypeContext(parent: global, identifier: "Class5", firstInheritedType: "Class1", kind: .class)
        // Tree:
        //  global
        //      class1
        //          class1_1
        //          class1_2
        //      class2
        //      class3
        //          class3_1
        //      class4
        //      class5
    }

    override func tearDownWithError() throws {
        global = nil
        class1 = nil
        class1_1 = nil
        class1_2 = nil
        class2 = nil
        class3 = nil
        class3_1 = nil
        class4 = nil
        class5 = nil
    }

    func testContextDepthPreOrderIterator() throws {
        var iterator = ContextDepthPreOrderIterator(root: global)

        var order: [Context] = []
        while let node = iterator.next() {
            order.append(node)
        }

        XCTAssertEqual(order, [global, class1, class1_1, class1_2, class2, class3, class3_1, class4, class5])
    }

    func testContextBreadthIterator() throws {
        var iterator = ContextBreadthIterator(root: global)

        var order: [Context] = []
        while let node = iterator.next() {
            order.append(node)
        }

        XCTAssertEqual(order, [global, class1, class2, class3, class4, class5, class1_1, class1_2, class3_1])
    }

}
