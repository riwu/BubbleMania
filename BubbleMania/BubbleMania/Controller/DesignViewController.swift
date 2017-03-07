//
//  DesignViewController.swift
//  LevelDesigner
//
//  Created by riwu on 31/1/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class DesignViewController: UIViewController {

    // fileprivate for extensions to access
    @IBOutlet fileprivate var collectionView: UICollectionView!
    fileprivate var gridView: GridView? //initialized in viewDidLoad

    @IBOutlet fileprivate var paletteButtons: [UIButton]!
    fileprivate var currentBubbleButton: UIButton?

    // public get for load function to access
    var gridBubbles = GridBubbles()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.embedControlPanelContainerView {
            if let controlPanelViewController = segue.destination as? ControlPanelViewController {
                controlPanelViewController.delegate = self
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        gridView = GridView(collectionView)

        loadPalette()

        setUpGestureRecognizers()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        panGesture.maximumNumberOfTouches = 1
        collectionView.addGestureRecognizer(panGesture)
    }

    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        collectionView.addGestureRecognizer(tapGesture)
    }

    private func setupLongPressGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(longPressHandler))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    private func setUpGestureRecognizers() {
        setupPanGestureRecognizer()
        setupTapGestureRecognizer()
        setupLongPressGestureRecognizer()
    }

    private func getCurrentIndexPath(_ recognizer: UIGestureRecognizer) -> IndexPath? {
        let location = recognizer.location(in: collectionView)
        return collectionView.indexPathForItem(at: location)
    }

    @objc
    private func panHandler(_ recognizer: UIPanGestureRecognizer) {
        guard let index = getCurrentIndexPath(recognizer)?.row else {
            return
        }
        if let bubble = getSelectedBubble() {
            if !gridBubbles.hasBubble(at: index) {
                addBubble(at: index, bubble)
            } else {
                changeBubble(at: index, to: bubble)
            }
        } else {
            deleteBubble(at: index)
        }
    }

    @objc
    private func tapHandler(_ recognizer: UITapGestureRecognizer) {
        guard let index = getCurrentIndexPath(recognizer)?.row else {
            return
        }
        if let selectedBubble = getSelectedBubble() {
            let currentBubble = gridBubbles.get(at: index)
            if currentBubble is NormalBubble && selectedBubble is NormalBubble {
                cycleBubble(at: index)
            } else if currentBubble?.type != selectedBubble.type {
                addBubble(at: index, selectedBubble)
            }
        } else {
            deleteBubble(at: index)
        }
    }

    @objc
    private func longPressHandler(_ recognizer: UILongPressGestureRecognizer) {
        guard let index = getCurrentIndexPath(recognizer)?.row else {
            return
        }
        deleteBubble(at: index)
    }

    private func addBubble(at index: Int, _ bubble: Bubble) {
        gridBubbles.add(at: index, bubble: bubble)
        gridView?.updateCell(newBubble: gridBubbles.get(at: index), at: index)
    }

    private func deleteBubble(at index: Int) {
        if gridBubbles.remove(at: index) {
            gridView?.updateCell(newBubble: gridBubbles.get(at: index), at: index)
        }
    }

    private func changeBubble(at index: Int, to newBubble: Bubble) {
        if let bubble = gridBubbles.get(at: index) {
            bubble.type = newBubble.type
            gridView?.updateCell(newBubble: gridBubbles.get(at: index), at: index)
        }
    }

    private func cycleBubble(at index: Int) {
        let bubble = gridBubbles.get(at: index)
        if let normalBubble = bubble as? NormalBubble {
            normalBubble.cycleColor()
            gridView?.updateCell(newBubble: gridBubbles.get(at: index), at: index)
        }
    }

}

extension DesignViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Constants.Grid.totalBubbleCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Grid.bubbleCellIdentifier,
                                                            for: indexPath) as? BubbleCell else {
            assert(false, "failed to deque as BubbleCell")
        }
        cell.addBackground()
        return cell
    }

}

extension DesignViewController: ControlPanelViewControllerDelegate {

    func updateAllCells() {
        gridView?.updateAllCells(gridBubbles: gridBubbles)
    }

}

// Palette functionalities
extension DesignViewController {

    fileprivate func loadPalette() {
        for paletteButton in paletteButtons {
            if paletteButton.tag == BubbleType.startTag {
                currentBubbleButton = paletteButton
                paletteButton.alpha = BubbleType.activeButtonOpacity
            } else {
                paletteButton.alpha = BubbleType.inactiveButtonOpacity
            }
        }
    }

    @IBAction private func paletteButtonPressed(_ sender: UIButton) {
        currentBubbleButton?.alpha = BubbleType.inactiveButtonOpacity
        currentBubbleButton = sender
        sender.alpha = BubbleType.activeButtonOpacity
    }

    fileprivate func getSelectedBubble() -> Bubble? {
        guard let buttonTag = currentBubbleButton?.tag else {
            assert(false, "No button active")
        }
        guard let button = BubbleType(rawValue: buttonTag) else {
            assert(false, "Invalid button")
        }
        if button == .empty {
            return nil
        }
        if let normalBubble = NormalBubble(type: button) {
            return normalBubble
        }
        return Bubble(type: button)
    }

}
