//
//  BubbleTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

@testable import BubbleMania
import XCTest

class BubbleTests: XCTestCase {

    func testBubbleInit() {
        XCTAssertEqual(Bubble(type: BubbleType.blue)?.type, BubbleType.blue,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(Bubble(type: BubbleType.green)?.type, BubbleType.green,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(Bubble(type: BubbleType.orange)?.type, BubbleType.orange,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(Bubble(type: BubbleType.red)?.type, BubbleType.red,
                       "Failed to initialize correct bubble")
    }

    func testBubbleInitFail() {
        XCTAssertNil(Bubble(type: BubbleType.empty), "Initialization of wrong type did not fail")
    }

}
