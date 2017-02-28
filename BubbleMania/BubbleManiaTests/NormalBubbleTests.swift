//
//  NormalBubbleTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

@testable import BubbleMania
import XCTest

class NormalBubbleTests: XCTestCase {

    func testNormalBubbleInit() {
        XCTAssertEqual(NormalBubble(type: BubbleType.blue)?.type, BubbleType.blue,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(NormalBubble(type: BubbleType.green)?.type, BubbleType.green,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(NormalBubble(type: BubbleType.orange)?.type, BubbleType.orange,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(NormalBubble(type: BubbleType.red)?.type, BubbleType.red,
                       "Failed to initialize correct bubble")
    }

    func testNormalBubbleInitFail() {
        XCTAssertNil(NormalBubble(type: BubbleType.empty),
                     "Initialization of wrong type did not fail")
    }

    func testNormalBubbleCycle() {
        let originallyBlueBubble = NormalBubble(type: BubbleType.blue)
        let blueBubbleCycleOrder = [BubbleType.green, BubbleType.orange,
                                    BubbleType.red, BubbleType.blue]
        for bubbleType in blueBubbleCycleOrder {
            originallyBlueBubble?.cycleColor()
            XCTAssertEqual(originallyBlueBubble?.type, bubbleType,
                           "Failed to cycle bubble correctly")
        }

        let originallyRedBubble = NormalBubble(type: BubbleType.red)
        let redBubbleCycleOrder = [BubbleType.blue, BubbleType.green,
                                   BubbleType.orange, BubbleType.red]
        for bubbleType in redBubbleCycleOrder {
            originallyRedBubble?.cycleColor()
            XCTAssertEqual(originallyRedBubble?.type, bubbleType,
                           "Failed to cycle bubble correctly")
        }
    }

    func testInitRandomNormalBubble() {
        XCTAssertNotNil(NormalBubble(), "Failed to generate random normal bubble correctly")
    }
}
