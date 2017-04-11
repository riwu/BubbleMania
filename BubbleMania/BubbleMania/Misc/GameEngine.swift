//
//  GameEngine.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import PhysicsEngine
import UIKit

class GameEngine {
    private let gridBubbles: GridBubbles
    private let initialGridBubbles = GridBubbles()
    private let gridView: GridView

    private let renderer: Renderer

    private let physicsEngine: PhysicsEngine

    private let launchCoordinate: CGPoint
    private var projectileBubbles = [ProjectileBubble]()
    private let bubbleRadius: CGFloat

    private var bubblesToBeLaunched = [NormalBubble]()

    private var isGameOver = false
    private var isShowingGameOver = false
    private var gameScore = 0

    init(controller: UIViewController, view: UIView, gridView: GridView, launchCoordinate: CGPoint,
         bubbleRadius: CGFloat, cannonView: UIImageView, cannonBubbleView: UIImageView,
         gridBubbles: GridBubbles, gameScoreLabel: UILabel) {
        self.gridView = gridView
        self.gridBubbles = gridBubbles
        initialGridBubbles.bubbles = gridBubbles.bubbles

        self.launchCoordinate = launchCoordinate
        self.bubbleRadius = bubbleRadius

        guard let physicsEngine = PhysicsEngine(leftBound: view.frame.minX, rightBound: view.frame.maxX,
                                                topBound: view.frame.minY,
                                                bottomBound: view.frame.maxY) else {
            fatalError("Invalid bounds")
        }
        self.physicsEngine = physicsEngine

        for _ in 1...Constants.Cannon.numOfbubblesToBeLaunched {
            bubblesToBeLaunched.append(NormalBubble())
        }

        renderer = Renderer(controller: controller, view: view, gridView: gridView,
                            bubblesToBeLaunched: bubblesToBeLaunched, bubbleRadius: bubbleRadius,
                            cannonView: cannonView, cannonBubbleView: cannonBubbleView,
                            gameScoreLabel: gameScoreLabel)

        _ = Timer.scheduledTimer(timeInterval: 1 / 60, target: self,
                                 selector: #selector(updateState), userInfo: nil, repeats: true)
    }

    @objc
    private func updateState() {
        guard !handlingGameOver() else {
            return
        }

        updateProjectileBubbleCoordinate()
        if hasSnappedBubbles() {
            renderer.updateView(gameScore: gameScore)
        }
        checkForCollidedProjectiles()
        renderer.updateView(projectileBubbles: projectileBubbles)
    }

    func renderGridBubbles() {
        for (index, bubble) in gridBubbles.bubbles {
            renderer.updateView(bubble: bubble, at: index)
        }
        removeFloatingBubbles()
    }

    func rotateCannon(to coordinate: CGPoint, launch: Bool, hasAimed: Bool) {
        let launchAngle = physicsEngine.getAngle(referencePoint: launchCoordinate,
                                                 selectedPoint: coordinate,
                                                 minAngle: Constants.Cannon.minAngle)

        let muzzleCoordinate = physicsEngine.rotate(point: launchCoordinate,
                                                    offset: Constants.Cannon.muzzleOffset,
                                                    angle: launchAngle)
        renderer.rotateCannon(launchAngle: launchAngle, muzzleCoordinate: muzzleCoordinate)

        if launch {
            launchBubble(launchAngle: launchAngle, muzzleCoordinate: muzzleCoordinate,
                         hasAimed: hasAimed)
        }
    }

    private func handlingGameOver() -> Bool {
        if isShowingGameOver {
            guard renderer.pressedRestart else {
                return true
            }

            isShowingGameOver = false
            renderer.pressedRestart = false
            isGameOver = false
            projectileBubbles.removeAll()

            gameScore = 0
            renderer.updateView(gameScore: gameScore)

            gridBubbles.bubbles = initialGridBubbles.bubbles
            for i in 0..<bubblesToBeLaunched.count {
                bubblesToBeLaunched[i] = NormalBubble()
            }
            renderer.updateView(gridBubbles: gridBubbles, bubblesToBeLaunched: bubblesToBeLaunched)
            removeFloatingBubbles()
            return false
        }

        if isGameOver {
            isShowingGameOver = true
            renderer.showGameOver(gameScore: gameScore)
            return true
        }

        return false
    }

    private func launchBubble(launchAngle: CGFloat, muzzleCoordinate: CGPoint, hasAimed: Bool) {
        let newProjectileBubble = ProjectileBubble(bubble: bubblesToBeLaunched.removeLast(),
                                                   coordinate: muzzleCoordinate,
                                                   velocity: physicsEngine.getVelocity(angle: launchAngle,
                                                                                       speed: Constants.Bubble.speed))
        projectileBubbles.append(newProjectileBubble)

        let newLaunchBubble = NormalBubble()
        bubblesToBeLaunched.insert(newLaunchBubble, at: 0)

        renderer.updateView(newLaunchBubble: newLaunchBubble, hasAimed: hasAimed)
    }

    private func updateProjectileBubbleCoordinate() {
        for projectileBubble in projectileBubbles {
            physicsEngine.setNextPosition(currentPos: &projectileBubble.coordinate,
                                          velocity: &projectileBubble.velocity,
                                          radius: bubbleRadius)
        }
    }

    private func hasSnappedBubbles() -> Bool {
        var result = false
        for (i, projectileBubble) in projectileBubbles.enumerated().reversed() {
            if physicsEngine.hasExitedBottomBound(yPos: projectileBubble.coordinate.y,
                                                  radius: bubbleRadius) {
                projectileBubbles.remove(at: i)
                continue
            }

            if physicsEngine.hasExceededTopBound(yPos: projectileBubble.coordinate.y,
                                                 radius: bubbleRadius) ||
                hasIntersectGridBubble(projectileBubble: projectileBubble) {
                handleCollision(collidedBubble: projectileBubble)
                projectileBubbles.remove(at: i)
                result = true
            }
        }
        return result
    }

    private func checkForCollidedProjectiles() {
        guard projectileBubbles.count > 1 else {
            return
        }

        for i in 0..<projectileBubbles.count - 1 {
            for j in i + 1..<projectileBubbles.count {
                physicsEngine.resolveCollidedCircles(center1: &projectileBubbles[i].coordinate,
                                                     center2: &projectileBubbles[j].coordinate,
                                                     velocity1: &projectileBubbles[i].velocity,
                                                     velocity2: &projectileBubbles[j].velocity,
                                                     radius: bubbleRadius)
            }
        }
    }

    private func hasIntersectGridBubble(projectileBubble: ProjectileBubble) -> Bool {
        for (index, _) in gridBubbles.bubbles {
            guard let bubbleCell = gridView.getCell(at: index) else {
                fatalError("Unable to get BubbleCell")
            }
            if physicsEngine.circlesIntersecting(center1: bubbleCell.center,
                                                 center2: projectileBubble.coordinate,
                                                 diameter: bubbleRadius * 2) {
                if index >= Constants.Grid.totalBubbleCount - Constants.Grid.numOfBubblesOnEvenRow {
                    isGameOver = true
                }
                return !isGameOver
            }
        }
        return false
    }

    private func handleCollision(collidedBubble: ProjectileBubble) {
        let snappedBubbleIndex = snapBubble(collidedBubble)
        if destroyBubbles(from: snappedBubbleIndex) {
            removeFloatingBubbles()
        }
    }

    private func snapBubble(_ collidedBubble: ProjectileBubble) -> Int {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestBubbleCell: UICollectionViewCell?
        for bubbleCell in gridView.getAllCells() {
            if !bubbleCell.contentView.subviews.isEmpty { // already has bubble
                continue
            }

            let distance = physicsEngine.getDistanceSquared(point1: bubbleCell.center,
                                                            point2: collidedBubble.coordinate)
            if distance > minDistance {
                continue
            }
            minDistance = distance
            closestBubbleCell = bubbleCell
        }
        guard let selectedBubbleCell = closestBubbleCell else {
            fatalError("Unable to get closest cell")
        }
        guard let index = gridView.collectionView.indexPath(for: selectedBubbleCell)?.row else {
            fatalError("Unable to get cell index")
        }
        guard let newBubble = NormalBubble(type: collidedBubble.type) else {
            fatalError("failed to create normal bubble")
        }
        gridBubbles.add(at: index, bubble: newBubble)

        renderer.updateView(bubble: newBubble, at: index)
        return index
    }

    private func destroyBubbles(from index: Int) -> Bool {
        var destroyedBubbles = getBubblesDestroyedBySpecialBubbles(startAt: index)

        let connectedBubblesOfTheSameType = getConnectedBubbles(at: index, sameType: true)
        if connectedBubblesOfTheSameType.count >= Constants.Bubble.minConnectedBubblesForRemoval {
            destroyedBubbles.formUnion(connectedBubblesOfTheSameType)
            gameScore += connectedBubblesOfTheSameType.count * Constants.Score.connectedNormalBubbles
        }

        // only count those removed by special bubbles
        gameScore += destroyedBubbles.subtracting(connectedBubblesOfTheSameType).count *
                     Constants.Score.specialBubbles
        gridBubbles.remove(destroyedBubbles)
        renderer.updateView(destroyedBubbleIndexes: destroyedBubbles)
        return !destroyedBubbles.isEmpty
    }

    private func getBubblesDestroyedBySpecialBubbles(startAt index: Int) -> Set<Int> {
        var bubblesToCheck = Set(getNeighbours(index).filter { bubbleIndex in
            guard let bubble = gridBubbles.get(at: bubbleIndex) else {
                return false
            }
            return !(bubble is NormalBubble) && bubble.type != .indestructible
        })

        var bubblesToRemove = Set<Int>()
        while let bubbleToCheck = bubblesToCheck.popFirst() {
            guard let bubbleType = gridBubbles.get(at: bubbleToCheck)?.type else {
                continue
            }

            bubblesToRemove.insert(bubbleToCheck)

            var indexes = Set<Int>()

            switch bubbleType {
            case .lightning:
                indexes = getBubblesOnSameRow(bubbleToCheck)
            case .bomb:
                indexes = getNeighbours(bubbleToCheck)
            case .star:
                indexes = getBubblesOfSameType(index)
            default:
                break
            }

            bubblesToCheck.formUnion(indexes.subtracting(bubblesToRemove))
        }

        return bubblesToRemove
    }

    private func getBubblesOnSameRow(_ index: Int) -> Set<Int> {
        let remainder = index % Constants.Grid.numOfBubblesOnOddAndEvenRow
        let remainderRowIndex = remainder / Constants.Grid.numOfBubblesOnOddRow
        let rowStart = index - remainder + Constants.Grid.numOfBubblesOnOddRow * remainderRowIndex
        let rowEnd = rowStart + Constants.Grid.numOfBubblesOnEvenRow - remainderRowIndex
        return Set(rowStart...rowEnd)
    }

    private func getBubblesOfSameType(_ index: Int) -> Set<Int> {
        guard let bubbleType = gridBubbles.get(at: index)?.type else {
            fatalError("Failed to get bubble type")
        }

        var result = Set<Int>()
        for (index, bubble) in gridBubbles.bubbles {
            if bubble.type == bubbleType {
                result.insert(index)
            }
        }
        return result
    }

    private func removeFloatingBubbles() {
        var floatingBubbles = Set<Int>()
        var unprocessedBubbles = Set(gridBubbles.bubbles.keys)
        while let index = unprocessedBubbles.popFirst() {
            let indexes = getConnectedBubbles(at: index)
            guard let lowestIndex = indexes.min() else {
                assertionFailure("getConnectedBubbles did not return any bubble")
                return
            }
            if lowestIndex >= Constants.Grid.numOfBubblesOnOddRow {
                floatingBubbles = floatingBubbles.union(indexes)
            }
            unprocessedBubbles.subtract(indexes)
        }

        gameScore += floatingBubbles.count * Constants.Score.floatingBubbles
        gridBubbles.remove(floatingBubbles)
        renderer.updateView(floatingBubbleIndexes: floatingBubbles)
    }

    private func getConnectedBubbles(at index: Int, sameType: Bool = false) -> Set<Int> {
        var result = Set<Int>()
        var frontier = Set<Int>()
        frontier.insert(index)
        while let index = frontier.popFirst() {
            result.insert(index)
            let validNeighbours = getValidNeighbours(at: index,
                                                     sameType: sameType, visitedSet: result)
            frontier = frontier.union(validNeighbours)
        }
        return result
    }

    private func getValidNeighbours(at index: Int, sameType: Bool,
                                    visitedSet: Set<Int>) -> Set<Int> {
        guard let bubbleType = gridBubbles.get(at: index)?.type else {
            fatalError("Unable to get bubble type")
        }

        var result = Set<Int>()

        for neighbour in getNeighbours(index) {
            if visitedSet.contains(neighbour) {
                continue
            }
            guard let bubble = gridBubbles.get(at: neighbour) else {
                continue
            }
            if sameType && bubble.type != bubbleType {
                continue
            }
            result.insert(neighbour)
        }

        return result
    }

    private func getNeighbours(_ index: Int) -> Set<Int> {
        var neighbours = Set<Int>()

        let columnNum = index % Constants.Grid.numOfBubblesOnOddAndEvenRow

        let topLeftIndex = index - Constants.Grid.numOfBubblesOnEvenRow - 1
        if topLeftIndex >= 0 && columnNum != 0 {
            neighbours.insert(topLeftIndex)
        }

        let topRightIndex = index - Constants.Grid.numOfBubblesOnEvenRow
        if topRightIndex >= 0 && columnNum != Constants.Grid.numOfBubblesOnEvenRow {
            neighbours.insert(topRightIndex)
        }

        let leftIndex = index - 1
        if leftIndex >= 0 &&
            columnNum != 0 &&
            columnNum != Constants.Grid.numOfBubblesOnOddRow {
            neighbours.insert(leftIndex)
        }

        let rightIndex = index + 1
        if rightIndex < Constants.Grid.totalBubbleCount &&
            columnNum != Constants.Grid.numOfBubblesOnEvenRow &&
            columnNum != Constants.Grid.numOfBubblesOnOddAndEvenRow - 1 {
            neighbours.insert(rightIndex)
        }

        let bottomLeftIndex = index + Constants.Grid.numOfBubblesOnEvenRow
        if bottomLeftIndex < Constants.Grid.totalBubbleCount && columnNum != 0 {
            neighbours.insert(bottomLeftIndex)
        }

        let bottomRightIndex = index + Constants.Grid.numOfBubblesOnOddRow
        if bottomRightIndex < Constants.Grid.totalBubbleCount &&
            columnNum != Constants.Grid.numOfBubblesOnEvenRow {
            neighbours.insert(bottomRightIndex)
        }
        return neighbours
    }
}
