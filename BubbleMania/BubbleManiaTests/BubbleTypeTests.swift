//
//  BubbleTypeTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0101010. All rights reserved.
//

@testable import BubbleMania
import XCTest

class BubbleTypeTests: XCTestCase {

    func testBubbleTypeInit() {
        XCTAssertEqual(BubbleType(rawValue: 1), BubbleType.blue,
                       "Failed to initialize correct button")
        XCTAssertEqual(BubbleType(rawValue: 2), BubbleType.green,
                       "Failed to initialize correct button")
        XCTAssertEqual(BubbleType(rawValue: 3), BubbleType.orange,
                       "Failed to initialize correct button")
        XCTAssertEqual(BubbleType(rawValue: 4), BubbleType.red,
                       "Failed to initialize correct button")
        XCTAssertEqual(BubbleType(rawValue: 9), BubbleType.empty,
                       "Failed to initialize correct button")
    }

    func testBubbleTypeInitFail() {
        XCTAssertNil(BubbleType(rawValue: 0), "Initialization of wrong tag did not fail")
        XCTAssertNil(BubbleType(rawValue: 10), "Initialization of wrong tag did not fail")
    }

    func testBubbleTypeOpacity() {
        XCTAssertLessThan(BubbleType.inactiveButtonOpacity, BubbleType.activeButtonOpacity)
    }

    func testBubbleTypeStartTag() {
        XCTAssertEqual(BubbleType.startTag, 1, "Start tag is not 1")
    }

}
