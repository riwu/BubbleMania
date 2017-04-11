//
//  PlayViewController.swift
//  BubbleMania
//
//  Created by riwu on 9/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet fileprivate var collectionView: UICollectionView!

    @IBOutlet private var cannonView: UIImageView!
    private var gameEngine: GameEngine?
    var gridBubbles = GridBubbles()

    @IBOutlet private var cannonBubbleView: UIImageView!

    @IBOutlet private var gameScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self

        setupTapGesture()
        setupLongpressGesture()
        setupPanGesture()

        let bubbleRadius = collectionView.contentSize.width /
                           CGFloat(Constants.Grid.numOfBubblesOnOddRow) / 2

        cannonView.layer.anchorPoint.y = 1
        cannonView.layer.position.y += cannonView.frame.height / 2

        gameEngine = GameEngine(controller: self, view: view, gridView: GridView(collectionView), launchCoordinate: cannonView.layer.position, bubbleRadius: bubbleRadius, cannonView: cannonView, cannonBubbleView: cannonBubbleView, gridBubbles: gridBubbles, gameScoreLabel: gameScoreLabel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gameEngine?.renderGridBubbles()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        collectionView.addGestureRecognizer(tapGesture)
    }

    private func setupLongpressGesture() {
        let longpressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(rotateCannon))
        longpressGesture.minimumPressDuration = 0.1
        collectionView.addGestureRecognizer(longpressGesture)
    }

    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(rotateCannon))
        panGesture.maximumNumberOfTouches = 1
        collectionView.addGestureRecognizer(panGesture)
    }

    @objc
    private func tapHandler(_ recognizer: UITapGestureRecognizer) {
        let coordinate = recognizer.location(in: collectionView)
        gameEngine?.rotateCannon(to: coordinate, launch: true, hasAimed: false)
    }

    @objc
    private func rotateCannon(_ recognizer: UIGestureRecognizer) {
        let coordinate = recognizer.location(in: collectionView)
        gameEngine?.rotateCannon(to: coordinate, launch: recognizer.state == .ended, hasAimed: true)
    }

}

extension PlayViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Constants.Grid.totalBubbleCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
                         .dequeueReusableCell(withReuseIdentifier: Constants.Grid.bubbleCellIdentifier,
                                              for: indexPath) as? BubbleCell else {
            fatalError("failed to deque as BubbleCell")
        }
        return cell
    }

}
