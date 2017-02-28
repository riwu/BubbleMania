//
//  Bubbles.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

class GridBubbles {

    // need public for save and load functionality
    var bubbles = [Int: Bubble]()

    func get(at index: Int) -> Bubble? {
        return bubbles[index]
    }

    func hasBubble(at index: Int) -> Bool {
        return get(at: index) != nil
    }

    func add(at index: Int, bubble: Bubble) {
        bubbles[index] = bubble
    }

    func remove(at index: Int) -> Bool {
        return bubbles.removeValue(forKey: index) != nil
    }

    func remove(_ set: Set<Int>) {
        for index in set {
            _ = remove(at: index)
        }
    }

}
