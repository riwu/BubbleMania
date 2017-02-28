//
//  MenuViewController.swift
//  BubbleMania
//
//  Created by riwu on 24/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    private var controlPanelViewController: ControlPanelViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let controlPanelViewController = storyboard?.instantiateViewController(withIdentifier: Constants.StoryBoardID.ControlPanelViewController) as? ControlPanelViewController else {
            assert(false, "Failed to instantiate ControlPanelViewController")
        }
        self.controlPanelViewController = controlPanelViewController
    }

    @IBAction func loadButtonPressed(_ button: UIButton) {
        controlPanelViewController?.loadButtonPressed(button, currentViewController: self)
    }

    @IBAction func levelButtonPressed(_ button: UIButton) {
        guard let file = Bundle.main.url(forResource: Constants.File.levelFiles[button.tag - 1],
                                         withExtension: Constants.File.fileExtension,
                                         subdirectory: Constants.File.levelDirectory) else {
            assert(false, "Failed to retrieve file")
        }
        controlPanelViewController?.loadBubblesAndPlay(file: file, currentViewController: self)
    }

}
