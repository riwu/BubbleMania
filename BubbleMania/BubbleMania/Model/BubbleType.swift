//
//  BubbleType.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

enum BubbleType: Int {

    // raw value is button tag, start from 1 to detect accidentally leaving tag at default of 0
    case blue = 1, green, orange, red, indestructible, lightning, bomb, star
    case empty
    static let startTag = blue.rawValue

    // for Level Design
    static let activeButtonOpacity = CGFloat(1.0)
    static let inactiveButtonOpacity = CGFloat(0.3)

    private static let blueBubbleFile = "bubble-blue"
    private static let greenBubbleFile = "bubble-green"
    private static let orangeBubbleFile = "bubble-orange"
    private static let redBubbleFile = "bubble-red"
    private static let indestructibleBubbleFile = "bubble-indestructible"
    private static let lightningBubbleFile = "bubble-lightning"
    private static let bombBubbleFile = "bubble-bomb"
    private static let starBubbleFile = "bubble-star"

    private static let emptyBubbleFile = "erase"

    private static let blueBubbleImage = UIImage(named: blueBubbleFile)
    private static let greenBubbleImage = UIImage(named: greenBubbleFile)
    private static let orangeBubbleImage = UIImage(named: orangeBubbleFile)
    private static let redBubbleImage = UIImage(named: redBubbleFile)

    private static let indestructibleBubbleImage = UIImage(named: indestructibleBubbleFile)
    private static let lightningBubbleImage = UIImage(named: lightningBubbleFile)
    private static let bombBubbleImage = UIImage(named: bombBubbleFile)
    private static let starBubbleImage = UIImage(named: starBubbleFile)

    private static let emptyBubbleImage = UIImage(named: emptyBubbleFile)

    var image: UIImage {
        switch self {
        case .blue:
            guard let bubbleImage = BubbleType.blueBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .green:
            guard let bubbleImage = BubbleType.greenBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .orange:
            guard let bubbleImage = BubbleType.orangeBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .red:
            guard let bubbleImage = BubbleType.redBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage

        case .indestructible:
            guard let bubbleImage = BubbleType.indestructibleBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .lightning:
            guard let bubbleImage = BubbleType.lightningBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .bomb:
            guard let bubbleImage = BubbleType.bombBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        case .star:
            guard let bubbleImage = BubbleType.starBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage

        case .empty:
            guard let bubbleImage = BubbleType.emptyBubbleImage else {
                fatalError("Image file not present")
            }
            return bubbleImage
        }
    }

}
