//
//  Renderer.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class Renderer {
    private let controller: UIViewController
    private let view: UIView
    private let gridView: GridView
    private let cannonView: UIImageView

    private let bubblesToBeLaunchedViews: [UIImageView]
    private var projectileBubbleViews = [UIImageView]()
    private let bubbleRadius: CGFloat

    private let cannonIdleImage: UIImage
    private let cannonAnimationImages: [UIImage]

    private let bubbleBurstImages: [UIImage]

    private let gameScoreLabel: UILabel

    var pressedRestart = false

    // method body is huge
    // cannot be refactored because instance method cannot be called until all properties are initialised
    init(controller: UIViewController, view: UIView, gridView: GridView,
         bubblesToBeLaunched: [NormalBubble], bubbleRadius: CGFloat, cannonView: UIImageView,
         cannonBubbleView: UIImageView, gameScoreLabel: UILabel) {
        self.controller = controller
        self.view = view
        self.gridView = gridView
        self.cannonView = cannonView
        self.bubbleRadius = bubbleRadius
        self.gameScoreLabel = gameScoreLabel

        // set up bubbles to be launched views
        var newBubblesView = [UIImageView]()
        for i in 0..<bubblesToBeLaunched.count - 1 {
            let xPos = view.frame.width / 2 / CGFloat(bubblesToBeLaunched.count) * CGFloat(i)

            guard let bubbleHolderImage = UIImage(named: Constants.Cannon.ballHolderFile) else {
                assert(false, "Unable to find ball holder image: " + Constants.Cannon.ballHolderFile)
            }

            let bubbleHolderView = UIImageView(image: bubbleHolderImage)
            let bubbleHolderSize = bubbleRadius * 2 + Constants.Cannon.bubbleHolderSizeDiff
            bubbleHolderView.frame = CGRect(x: xPos, y: view.frame.height - bubbleHolderSize,
                                            width: bubbleHolderSize, height: bubbleHolderSize)
            view.addSubview(bubbleHolderView)

            let upcomingBubbleView = UIImageView(image: bubblesToBeLaunched[i].image)
            upcomingBubbleView.frame = CGRect(x: bubbleHolderView.frame.origin.x +
                                                 bubbleHolderView.frame.width / 2 - bubbleRadius,
                                              y: bubbleHolderView.frame.origin.y +
                                                 bubbleHolderView.frame.height / 2 - bubbleRadius,
                                              width: bubbleRadius * 2, height: bubbleRadius * 2)
            newBubblesView.append(upcomingBubbleView)
            view.addSubview(upcomingBubbleView)
        }

        guard let lastBubbleImage = bubblesToBeLaunched.last?.image else {
            assert(false, "Failed to get last bubble image")
        }
        cannonBubbleView.image = lastBubbleImage
        newBubblesView.append(cannonBubbleView)
        view.addSubview(cannonBubbleView)

        bubblesToBeLaunchedViews = newBubblesView

        //cannon
        guard let cannonIdleImage = UIImage(named: Constants.Cannon.cannonIdleFile) else {
            assert(false, "Failed to find cannon image: " + Constants.Cannon.cannonIdleFile)
        }
        self.cannonIdleImage = cannonIdleImage

        var animationImages = [UIImage]()
        for cannonAnimationFile in Constants.Cannon.cannonAnimationFiles {
            guard let cannonAnimationImage = UIImage(named: cannonAnimationFile) else {
                assert(false, "Failed to find cannon image: " + cannonAnimationFile)
            }
            animationImages.append(cannonAnimationImage)
        }
        cannonAnimationImages = animationImages
        cannonView.animationRepeatCount = 1

        //bubble burst images
        guard let burstSprites = UIImage(named: Constants.Bubble.burstSpriteFile)?.cgImage else {
            assert(false, "Failed to find file " + Constants.Bubble.burstSpriteFile)
        }
        var burstImages = [UIImage]()
        let burstImageWidth = burstSprites.width / Constants.Bubble.burstSpriteCount
        for i in 0..<Constants.Bubble.burstSpriteCount {
            let rect = CGRect(x: burstImageWidth * i, y: 0, width: burstImageWidth, height: burstSprites.height)
            guard let bubbleAnimationImage = burstSprites.cropping(to: rect) else {
                assert(false, "Failed to create crop image")
            }
            burstImages.append(UIImage(cgImage: bubbleAnimationImage))
        }
        bubbleBurstImages = burstImages
    }

    func updateView(newLaunchBubble: Bubble, hasAimed: Bool) {
        for i in stride(from: bubblesToBeLaunchedViews.count - 1, to: 0, by: -1) {
            bubblesToBeLaunchedViews[i].image = bubblesToBeLaunchedViews[i - 1].image
        }
        bubblesToBeLaunchedViews.first?.image = newLaunchBubble.image

        cannonView.image = cannonIdleImage

        cannonView.animationImages = hasAimed ? Array(cannonAnimationImages.dropFirst()) : cannonAnimationImages
        cannonView.animationDuration = Double(cannonView.animationImages?.count ?? 0) * Constants.Cannon.animationDurationPerImage

        cannonView.startAnimating()
    }

    func updateView(bubble: Bubble, at index: Int) {
        gridView.updateCell(newBubble: bubble, at: index)
    }

    func updateView(destroyedBubbleIndexes: Set<Int>) {
        for index in destroyedBubbleIndexes {
            guard let bubbleCell = gridView.getCell(at: index) else {
                assert(false, "Cant get BubbleCell")
            }
            guard let bubbleView = bubbleCell.contentView.subviews.first as? UIImageView else {
                assert(false, "Cant get ImageView")
            }

            bubbleView.removeFromSuperview()
            bubbleView.frame = bubbleCell.frame
            view.addSubview(bubbleView)

            // due to time synchronisation issue between startAnimating and perform, 
            // set image to new and delay removal to ensure animation completion
            bubbleView.image = UIImage()
            bubbleView.animationDuration = Constants.Bubble.burstDuration
            bubbleView.animationRepeatCount = 1
            bubbleView.animationImages = bubbleBurstImages
            bubbleView.startAnimating()
            bubbleView.perform(#selector(removeFromSuperview), with: nil, afterDelay: Constants.Bubble.burstDuration * 2)
        }
    }

    @objc // declare method as @objc for selector to access
    private func removeFromSuperview() {}

    func updateView(floatingBubbleIndexes: Set<Int>) {
        for index in floatingBubbleIndexes {
            guard let bubbleCell = gridView.getCell(at: index) else {
                assert(false, "Cant get BubbleCell")
            }
            guard let bubbleView = bubbleCell.contentView.subviews.first as? UIImageView else {
                assert(false, "Cant get ImageView")
            }

            bubbleView.removeFromSuperview()

            bubbleView.frame = CGRect(x: bubbleCell.frame.origin.x,
                                      y: bubbleCell.frame.origin.y,
                                      width: bubbleCell.frame.width,
                                      height: bubbleCell.frame.height +
                                              Constants.Bubble.fallDistance)
            bubbleView.contentMode = .scaleAspectFit
            view.addSubview(bubbleView)

            UIView.animate(withDuration: Constants.Bubble.fallDuration, delay: 0, options: .curveEaseIn, animations: {
                bubbleView.frame = CGRect(
                    x: bubbleView.frame.origin.x,
                    y: bubbleView.frame.origin.y + Constants.Bubble.fallDistance,
                    width: bubbleView.frame.width,
                    height: bubbleView.frame.height)

                bubbleView.alpha = 0
            }, completion: { _ in
                bubbleView.removeFromSuperview()
            })
        }
    }

    func updateView(projectileBubbles: [ProjectileBubble]) {
        while let projectileBubbleView = projectileBubbleViews.popLast() {
            projectileBubbleView.removeFromSuperview()
        }

        for projectileBubble in projectileBubbles {
            let projectileBubbleView = UIImageView(image: projectileBubble.image)
            projectileBubbleView.frame = CGRect(x: projectileBubble.coordinate.x - bubbleRadius,
                                                y: projectileBubble.coordinate.y - bubbleRadius,
                                                width: bubbleRadius * 2, height: bubbleRadius * 2)
            projectileBubbleViews.append(projectileBubbleView)
            view.addSubview(projectileBubbleView)
        }
    }

    func updateView(gridBubbles: GridBubbles, bubblesToBeLaunched: [Bubble]) {
        gridView.updateAllCells(gridBubbles: gridBubbles)
        for (bubblesToBeLaunchedView, bubbleToBeLaunched) in zip(bubblesToBeLaunchedViews, bubblesToBeLaunched) {
            bubblesToBeLaunchedView.image = bubbleToBeLaunched.image
        }
    }

    func updateView(gameScore: Int) {
        gameScoreLabel.text = "Score\n" + String(gameScore)
    }

    func rotateCannon(launchAngle: CGFloat, muzzleCoordinate: CGPoint) {
        let angleChange = Constants.Cannon.startAngle - launchAngle

        cannonView.transform = CGAffineTransform(rotationAngle: angleChange)
        cannonView.image = cannonAnimationImages.first

        guard let cannonBubbleView = bubblesToBeLaunchedViews.last else {
            assert(false, "Cant get cannonBubbleView")
        }
        let yOffset = cannonView.layer.position.y - cannonBubbleView.layer.position.y
        cannonBubbleView.transform = CGAffineTransform(translationX: 0, y: yOffset)
                                     .rotated(by: angleChange)
                                     .translatedBy(x: 0, y: -yOffset)
    }

    func showGameOver(gameScore: Int) {
        let gameOverController = UIAlertController(title: "Game Over", message: "Score: " + String(gameScore), preferredStyle: .alert)

        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            self.pressedRestart = true
        }
        gameOverController.addAction(restartAction)

        controller.present(gameOverController, animated: true, completion: nil)
    }

}
