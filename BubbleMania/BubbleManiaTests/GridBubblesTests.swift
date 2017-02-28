//
//  GridBubblesTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

@testable import BubbleMania
import XCTest

class GridBubblesTests: XCTestCase {

    func testGridBubblesInit() {
        XCTAssert(NSDictionary(dictionary: GridBubbles().bubbles).isEqual(to: [:]),
                  "Failed to init GridBubbles")
    }

    func testGridBubblesAdd() {
        let gridBubbles = GridBubbles()
        guard let bubble = Bubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        guard let normalBubble = NormalBubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        gridBubbles.add(at: 0, bubble: bubble)
        gridBubbles.add(at: 1, bubble: bubble)
        gridBubbles.add(at: 1, bubble: normalBubble)
        XCTAssert(NSDictionary(dictionary: gridBubbles.bubbles)
                  .isEqual(to: [0: bubble, 1: normalBubble]), "Failed to add bubble")
    }

    func testGridBubblesRemoveEmpty() {
        XCTAssertFalse(GridBubbles().remove(at: 0),
                       "Did not remove bubble but still returned true!")
    }

    func testGridBubblesRemove() {
        let gridBubbles = GridBubbles()
        guard let bubble = Bubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        guard let normalBubble = NormalBubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        gridBubbles.add(at: 0, bubble: bubble)
        gridBubbles.add(at: 1, bubble: normalBubble)
        XCTAssert(gridBubbles.remove(at: 0), "Removed bubble but returned false")
        XCTAssert(NSDictionary(dictionary: gridBubbles.bubbles).isEqual(to: [1: normalBubble]),
                  "Failed to remove bubble")
    }

    func testGridBubblesGet() {
        let gridBubbles = GridBubbles()
        guard let bubble = Bubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        gridBubbles.add(at: 0, bubble: bubble)
        XCTAssertNil(gridBubbles.get(at: 1), "Gotten bubble when there's no bubble!")
        XCTAssertEqual(gridBubbles.get(at: 0)?.type, BubbleType.blue,
                       "Did not get correct bubble")
    }

    func testGridBubblesHasBubble() {
        let gridBubbles = GridBubbles()
        guard let bubble = Bubble(type: BubbleType.blue) else {
            XCTAssert(false)
            return
        }
        gridBubbles.add(at: 0, bubble: bubble)
        XCTAssertFalse(gridBubbles.hasBubble(at: 1), "Returned has bubble when there's no bubble")
        XCTAssertTrue(gridBubbles.hasBubble(at: 0), "Returned no bubble when there's bubble")
    }

}
