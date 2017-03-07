//
//  PhysicsEngine.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

public class PhysicsEngine {

    private let topBound: CGFloat
    private let bottomBound: CGFloat
    private let leftBound: CGFloat
    private let rightBound: CGFloat

    public init?(leftBound: CGFloat, rightBound: CGFloat, topBound: CGFloat, bottomBound: CGFloat) {
        if (leftBound > rightBound) || (topBound > bottomBound) {
            return nil
        }
        self.topBound = topBound
        self.bottomBound = bottomBound
        self.rightBound = rightBound
        self.leftBound = leftBound
    }

    public func getAngle(referencePoint: CGPoint, selectedPoint: CGPoint, minAngle: CGFloat) -> CGFloat {
        return adjustAngle(atan2(referencePoint.y - selectedPoint.y,
                                 selectedPoint.x - referencePoint.x), minAngle: minAngle)
    }

    private func adjustAngle(_ angle: CGFloat, minAngle: CGFloat) -> CGFloat {
        if angle >= 0 + minAngle && angle <= CGFloat.pi - minAngle {
            return angle
        }
        return (abs(angle) < CGFloat.pi / 2) ? (0 + minAngle) : (CGFloat.pi - minAngle)
    }

    public func getVelocity(angle: CGFloat, speed: CGFloat) -> CGPoint {
        return CGPoint(x: speed * cos(angle), y: speed * sin(angle))
    }

    // if out of left/right bounds, reflect and move it in
    public func setNextPosition(currentPos: inout CGPoint,
                                velocity: inout CGPoint, radius: CGFloat) {
        currentPos.x += velocity.x
        currentPos.y -= velocity.y
        if hasExceededLeftBound(xPos: currentPos.x, radius: radius) {
            velocity.x = -velocity.x
            currentPos.x = leftBound + radius
        } else if hasExceededRightBound(xPos: currentPos.x, radius: radius) {
            velocity.x = -velocity.x
            currentPos.x = rightBound - radius
        }
    }

    public func hasExceededLeftBound(xPos: CGFloat, radius: CGFloat) -> Bool {
        return leftBound >= xPos - radius
    }

    public func hasExceededRightBound(xPos: CGFloat, radius: CGFloat) -> Bool {
        return rightBound <= xPos + radius
    }

    public func hasExceededTopBound(yPos: CGFloat, radius: CGFloat) -> Bool {
        return topBound >= yPos - radius
    }

    public func hasExceededBottomBound(yPos: CGFloat, radius: CGFloat) -> Bool {
        return bottomBound <= yPos + radius
    }

    public func hasExitedBottomBound(yPos: CGFloat, radius: CGFloat) -> Bool {
        return bottomBound <= yPos - radius
    }

    public func circlesIntersecting(center1: CGPoint, center2: CGPoint, diameter: CGFloat) -> Bool {
        return getDistanceSquared(point1: center1, point2: center2) <= (diameter * diameter)
    }

    // more efficient than computing sqrt when distance is only used for comparison
    public func getDistanceSquared(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let diffX = point1.x - point2.x
        let diffY = point1.y - point2.y
        return diffX * diffX + diffY * diffY
    }

    public func rotate(point: CGPoint, offset: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: point.x + cos(angle) * offset, y: point.y - sin(angle) * offset)
    }

    public func resolveCollidedCircles(center1: inout CGPoint, center2: inout CGPoint,
                                       velocity1: inout CGPoint,
                                       velocity2: inout CGPoint, radius: CGFloat) {
        if !circlesIntersecting(center1: center1, center2: center2, diameter: radius * 2) {
            return
        }
        separateCollidedCircles(center1: &center1, center2: &center2, radius: radius)
        setVelocityAfterCollision(center1: &center1, center2: &center2,
                                  velocity1: &velocity1, velocity2: &velocity2, radius: radius)
    }

    private func separateCollidedCircles(center1: inout CGPoint,
                                         center2: inout CGPoint, radius: CGFloat) {
        let midPointX = (center1.x + center2.x) / 2
        let midPointY = (center1.y + center2.y) / 2

        let distance = max(1, sqrt(getDistanceSquared(point1: center1, point2: center2)))

        let distVectorX = radius * (center1.x - center2.x) / distance
        let distVectorY = radius * (center1.y - center2.y) / distance

        center1.x = midPointX + distVectorX
        center1.y = midPointY + distVectorY
        center2.x = midPointX - distVectorX
        center2.y = midPointY - distVectorY
    }

    private func setVelocityAfterCollision(center1: inout CGPoint, center2: inout CGPoint,
                                           velocity1: inout CGPoint,
                                           velocity2: inout CGPoint, radius: CGFloat) {
        let distance = radius * 2
        let normalX = (center2.x - center1.x) / distance
        let normalY = (center2.y - center1.y) / distance
        let point = (velocity1.x - velocity2.x) * normalX + (velocity1.y - velocity2.y) * normalY
        let velocityX = point * normalX
        let velocityY = point * normalY

        velocity1.x -= velocityX
        velocity1.y -= velocityY
        velocity2.x += velocityX
        velocity2.y += velocityY
    }

}
