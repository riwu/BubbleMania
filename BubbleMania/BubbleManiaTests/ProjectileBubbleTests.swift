//
//  ProjectileBubbleTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

@testable import BubbleMania
import XCTest

class ProjectileBubbleTests: XCTestCase {

    func testProjectileBubbleInit() {
        let normalBubble = NormalBubble()
        let projectileBubble = ProjectileBubble(bubble: normalBubble,
                                                coordinate: CGPoint(x: 1.2, y: 1.3),
                                                velocity: CGPoint(x: 10, y: 10))
        XCTAssertEqual(projectileBubble.type, normalBubble.type,
                       "Failed to initialize correct bubble")
        XCTAssertEqual(projectileBubble.coordinate, CGPoint(x: 1.2, y: 1.3),
                       "Failed to initialize correct coordinates")
        XCTAssertEqual(projectileBubble.velocity, CGPoint(x: 10, y: 10),
                       "Failed to initialize correct angle")
    }

}
