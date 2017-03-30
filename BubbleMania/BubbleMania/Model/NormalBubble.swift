//
//  NormalBubble.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import Foundation

class NormalBubble: Bubble {

    private static let bubbleTypes = [BubbleType.blue, BubbleType.green,
                                      BubbleType.orange, BubbleType.red]

    override init?(type: BubbleType) {
        if !(NormalBubble.bubbleTypes.contains(type)) {
            return nil
        }
        super.init(type: type)
    }

    convenience init() {
        let randBubbleTag = Int(arc4random_uniform(UInt32(NormalBubble.bubbleTypes.count))) +
            BubbleType.startTag
        guard let bubbleType = BubbleType(rawValue: randBubbleTag) else {
            fatalError("Invalid random number generated")
        }
        assert(NormalBubble.bubbleTypes.contains(bubbleType), "Invalid normal bubble type")
        self.init(type: bubbleType)! // force-unwrap since guaranteed to be valid type
    }

    func cycleColor() {
        let newValue = (type.rawValue == BubbleType.startTag + NormalBubble.bubbleTypes.count - 1) ?
            BubbleType.startTag :
            type.rawValue + 1
        guard let newType = BubbleType(rawValue: newValue) else {
            assertionFailure("Cycled to invalid type")
            return
        }
        type = newType
    }

}
