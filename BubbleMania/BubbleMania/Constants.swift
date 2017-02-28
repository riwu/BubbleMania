//
//  Constants.swift
//  BubbleMania
//
//  Created by riwu on 19/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

struct Constants {

    struct Segue {
        static let startGame = "startGame"
        static let embedControlPanelContainerView = "embedControlPanelContainerView"
    }

    struct StoryBoardID {
        static let PlayViewController = "PlayViewController"
        static let ControlPanelViewController = "ControlPanelViewController"
    }

    struct Cannon {
        static let cannonIdleFile = "cannon-idle"
        static let cannonAnimationFiles = ["cannon-shot-2", "cannon-shot-3", "cannon-shot-4"]
        static let animationDurationPerImage = 0.1

        static let ballHolderFile = "ball-holder"
        static let bubbleHolderSizeDiff = CGFloat(28)

        static let muzzleOffset = CGFloat(180)

        static let startAngle = CGFloat.pi / 2
        static let minAngle = CGFloat(0.1)

        static let numOfbubblesToBeLaunched = 4
    }

    struct Grid {
        static let numOfBubblesOnOddRow = 12
        static let numOfBubblesOnEvenRow = numOfBubblesOnOddRow - 1
        static let numOfBubblesOnOddAndEvenRow = numOfBubblesOnOddRow + numOfBubblesOnEvenRow
        static let numOfOddAndEvenRows = 7
        static let totalBubbleCount = numOfBubblesOnOddAndEvenRow * numOfOddAndEvenRows

        static let bubbleCellIdentifier = "bubbleCell"
    }

    struct Bubble {
        static let burstDuration = 0.8
        static let burstSpriteFile = "bubble-burst"
        static let burstSpriteCount = 4

        static let fallDistance = CGFloat(120)
        static let fallDuration = 1.0

        static let minConnectedBubblesForRemoval = 3
        static let speed = CGFloat(15.0)
    }

    struct Score {
        static let connectedNormalBubbles = 10
        static let specialBubbles = 20
        static let floatingBubbles = 30
    }

    struct File {
        static let fileExtension = "plist"
        static let levelFiles = ["1", "2", "3"]
        static let levelDirectory = "Levels"
    }
}
