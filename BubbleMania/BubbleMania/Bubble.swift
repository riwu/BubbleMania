//
//  Bubble.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class Bubble {

    var type: BubbleType
    var image: UIImage {
        return type.image
    }

    init?(type: BubbleType) {
        if type == .empty {
            return nil
        }
        self.type = type
    }

    init(_ bubble: Bubble) {
        type = bubble.type
    }

}
