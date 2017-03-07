//
//  BubbleCell.swift
//  BubbleMania
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class BubbleCell: UICollectionViewCell {

    private static var opacity = 0.6

    func addBackground() {
        let radius = CGFloat(frame.size.width / 2)
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius,
                                      startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.gray.withAlphaComponent(CGFloat(BubbleCell.opacity)).cgColor

        backgroundView = UIView(frame: frame)
        backgroundView?.layer.addSublayer(shapeLayer)
    }

}
