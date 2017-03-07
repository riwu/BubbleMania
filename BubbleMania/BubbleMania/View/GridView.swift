//
//  GridView.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class GridView {
    let collectionView: UICollectionView

    private static let sectionNum = 0

    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    func updateCell(_ cell: BubbleCell, newBubble: Bubble?, at index: Int) {
        let bubbleViewOptional = cell.contentView.subviews.first as? UIImageView

        if let bubble = newBubble {
            if let bubbleView = bubbleViewOptional {
                bubbleView.image = bubble.image
            } else {
                let newBubble = UIImageView(image: bubble.image)
                newBubble.frame.size = cell.frame.size
                cell.contentView.addSubview(newBubble)
            }
        } else {
            if let bubbleView = bubbleViewOptional {
                bubbleView.removeFromSuperview()
            }
        }
    }

    func updateCell(newBubble: Bubble?=nil, at index: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: index,
                                                                  section: GridView.sectionNum))
                                                                             as? BubbleCell else {
            assert(false, "Failed to retrieve bubble cell at " + String(index))
        }
        updateCell(cell, newBubble: newBubble, at: index)
    }

    func updateCell(newBubble: Bubble?=nil, at indexes: Set<Int>) {
        for index in indexes {
            updateCell(at: index)
        }
    }

    func getAllCells() -> [BubbleCell] {
        return collectionView.visibleCells.flatMap {
            $0 as? BubbleCell
        }
    }

    func getCell(at index: Int) -> BubbleCell? {
        return collectionView.cellForItem(at: IndexPath(row: index,
                                                        section: GridView.sectionNum)) as? BubbleCell
    }

    func updateAllCells(gridBubbles: GridBubbles) {
        for bubbleCell in getAllCells() {
            if let index = collectionView.indexPath(for: bubbleCell)?.row {
                updateCell(bubbleCell, newBubble: gridBubbles.get(at: index), at: index)
            }
        }
    }
}
