//
//  ProjectileBubble.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class ProjectileBubble: Bubble {
    var coordinate: CGPoint
    var velocity: CGPoint

    init(bubble: Bubble, coordinate: CGPoint, velocity: CGPoint) {
        self.coordinate = coordinate
        self.velocity = velocity
        super.init(bubble)
    }
}
