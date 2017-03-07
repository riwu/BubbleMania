//
//  BubbleViewFlowLayout.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class BubbleViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        let diameter = collectionViewContentSize.width / CGFloat(Constants.Grid.numOfBubblesOnOddRow)
        itemSize = CGSize(width: diameter, height: diameter)

        for i in 0..<attributes.count {
            let index = i % Constants.Grid.numOfBubblesOnOddAndEvenRow
            let x = (index < Constants.Grid.numOfBubblesOnOddRow) ?
                itemSize.width * CGFloat(index) :
                itemSize.width * CGFloat(index - Constants.Grid.numOfBubblesOnOddRow) +
                itemSize.width / 2
            let y = CGFloat(index / Constants.Grid.numOfBubblesOnOddRow +
                i / Constants.Grid.numOfBubblesOnOddAndEvenRow * 2) *
                itemSize.width / 2 * sqrt(3)
            attributes[i].frame = CGRect(origin: CGPoint(x: x, y: y), size: attributes[i].frame.size)
        }

        return attributes
    }

}
