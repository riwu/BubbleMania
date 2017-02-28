//
//  PhysicsEngineTests.swift
//  BubbleMania
//
//  Created by riwu on 12/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

@testable import BubbleMania
import PhysicsEngine
import XCTest

class PhysicsEngineTests: XCTestCase {

    func testPhysicsEngineInit() {
        XCTAssertNotNil(PhysicsEngine(leftBound: 0, rightBound: 0, topBound: 0, bottomBound: 0),
                        "Initialization of bounds failed")
        XCTAssertNotNil(PhysicsEngine(leftBound: 0, rightBound: 10, topBound: 0, bottomBound: 10),
                        "Initialization of bounds failed")
    }

    func testPhysicsEngineInitFail() {
        XCTAssertNil(PhysicsEngine(leftBound: 10, rightBound: 5, topBound: 0, bottomBound: 10),
                     "Initialization of wrong bounds did not fail")
        XCTAssertNil(PhysicsEngine(leftBound: 0, rightBound: 10, topBound: 5, bottomBound: 0),
                     "Initialization of wrong bounds did not fail")
    }

    func testGetAngle() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssertEqualWithAccuracy(physicsEngine.getAngle(referencePoint: CGPoint(x: 5, y: 100),
                                                          selectedPoint: CGPoint(x: 40, y: 80),
                                                          minAngle: 0),
                                   CGFloat(0.519), accuracy: 0.001, "Wrong calculation of angle")
        XCTAssertEqualWithAccuracy(physicsEngine.getAngle(referencePoint: CGPoint(x: 70, y: -50),
                                                          selectedPoint: CGPoint(x: -40, y: 800),
                                                          minAngle: 0.1),
                                   CGFloat(3.041), accuracy: 0.001, "Wrong calculation of angle")
    }

    func testSetNextPosition() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        var point = CGPoint(x: 5, y: 10)
        var velocity = CGPoint(x: 8.0, y: 10.2)
        physicsEngine.setNextPosition(currentPos: &point, velocity: &velocity,
                                      radius: CGFloat(55))

        XCTAssertEqualWithAccuracy(point.x, CGFloat(55.0), accuracy: 0.001,
                                   "Failed to calculate next position correctly")
        XCTAssertEqualWithAccuracy(point.y, CGFloat(-0.2), accuracy: 0.001,
                                   "Failed to calculate next position correctly")
        XCTAssertEqualWithAccuracy(velocity.x, -8.0, accuracy: 0.001,
                                   "Failed to calculate next angle correctly")
        XCTAssertEqualWithAccuracy(velocity.y, 10.2, accuracy: 0.001,
                                   "Failed to calculate next angle correctly")
    }

    func testHasExceededTopBound() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssert(physicsEngine.hasExceededTopBound(yPos: 3, radius: 4),
                  "hasExceededTopBound wrong result")
        XCTAssertFalse(physicsEngine.hasExceededTopBound(yPos: 5, radius: 4),
                       "hasExceededTopBound wrong result")
    }

    func testHasExceededBottomBound() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssert(physicsEngine.hasExceededBottomBound(yPos: 8, radius: 4),
                  "hasExceededBottomBound wrong result")
        XCTAssertFalse(physicsEngine.hasExceededBottomBound(yPos: 5, radius: 4),
                       "hasExceededBottomBound wrong result")
    }

    func testHasExceededLeftBound() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssert(physicsEngine.hasExceededLeftBound(xPos: 3, radius: 4),
                  "hasExceededLeftBound wrong result")
        XCTAssertFalse(physicsEngine.hasExceededLeftBound(xPos: 5, radius: 4),
                       "hasExceededLeftBound wrong result")
    }

    func testHasExceededRightBound() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssert(physicsEngine.hasExceededRightBound(xPos: 6, radius: 4),
                  "hasExceededRightBound wrong result")
        XCTAssertFalse(physicsEngine.hasExceededRightBound(xPos: 3, radius: 4),
                       "hasExceededRightBound wrong result")
    }

    func testGetDistanceSquared() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssertEqualWithAccuracy(physicsEngine.getDistanceSquared(point1: CGPoint(x: 15, y: 17),
                                                                    point2: CGPoint(x: 32, y: 34)),
                                   CGFloat(578), accuracy: 0.001,
                                   "getDistanceSquared returned wrong value")
        XCTAssertEqualWithAccuracy(physicsEngine.getDistanceSquared(point1: CGPoint(x: 0, y: 5),
                                                                    point2: CGPoint(x: -12, y: -15)),
                                   CGFloat(544), accuracy: 0.001,
                                   "getDistanceSquared returned wrong value")
    }

    func testCirclesIntersecting() {
        guard let physicsEngine = PhysicsEngine(leftBound: 0, rightBound: 10,
                                                topBound: 0, bottomBound: 10) else {
            XCTAssert(false, "Failed to initialise physics engine")
            return
        }
        XCTAssert(physicsEngine.circlesIntersecting(center1: CGPoint(x: 15, y: 17),
                                                    center2: CGPoint(x: 32, y: 34),
                                                    diameter: CGFloat(24.1)))
        XCTAssertFalse(physicsEngine.circlesIntersecting(center1: CGPoint(x: 15, y: 17),
                                                         center2: CGPoint(x: 32, y: 34),
                                                         diameter: CGFloat(24)))

        XCTAssert(physicsEngine.circlesIntersecting(center1: CGPoint(x: 0, y: 5),
                                                    center2: CGPoint(x: -12, y: -15),
                                                    diameter: CGFloat(23.4)))
        XCTAssertFalse(physicsEngine.circlesIntersecting(center1: CGPoint(x: 0, y: 5),
                                                         center2: CGPoint(x: -12, y: -15),
                                                         diameter: CGFloat(23.3)))
    }
}
