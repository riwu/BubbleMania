//
//  ControlPanelViewController.swift
//  LevelDesigner
//
//  Created by riwu on 1/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import UIKit

enum FileError: LocalizedError {

    case failToRetrieveDocumentDirectory
    case failToLoadFile(fileName: String)
    case wrongTag(tag: Int)
    case indexNotInt(indexStr: String)
    case failToWrite(fileName: String)
    case invalidFileName(String)

    var errorDescription: String? {
        switch self {
        case .failToRetrieveDocumentDirectory:
            return "Failed to retrieve document directory"
        case .failToLoadFile(let fileName):
            return "Failed to load file: " + fileName
        case .wrongTag(let tag):
            return "File contains wrong button tag: " + String(tag)
        case .indexNotInt(let indexStr):
            return "File contains non-int index str: " + indexStr
        case .failToWrite(let fileName):
            return "Failed to write to file: " + fileName
        case .invalidFileName(let fileName):
            return "Invalid file name: " + fileName
        }
    }

}

protocol ControlPanelViewControllerDelegate: class {

    var gridBubbles: GridBubbles { get set }
    func updateAllCells()

}

extension ControlPanelViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let fileName = textField.text?.trimmingCharacters(in: .whitespaces) else {
            assertionFailure("No text field")
            return false
        }

        if !fileName.isEmpty {
            saveToNewFile(fileName)
        }

        return false
    }

}

class ControlPanelViewController: UIViewController {

    weak var delegate: ControlPanelViewControllerDelegate?

    private var lastFileAccessed: URL?

    private var gridBubbles = GridBubbles()
    private var currentViewController: UIViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.startGame {
            guard let playViewController = segue.destination as? PlayViewController else {
                return
            }
            guard let delegateBubbles = delegate?.gridBubbles else {
                return
            }
            playViewController.gridBubbles = delegateBubbles
        }
    }

    @IBAction private func saveButtonPressed(_ button: UIButton) {
        guard let fileSelectController = createFileSelectController(button: button,
                                                                    fileAction: saveToFile) else {
            return
        }

        present(fileSelectController, animated: true, completion: nil)
    }

    @IBAction private func saveNewButtonPressed(_ button: UIButton) {
        let fileSelectController = UIAlertController(title: "Enter a new file name",
                                                     message: nil, preferredStyle: .alert)

        fileSelectController.addTextField { textField in
            textField.delegate = self
        }

        addCancelAction(controller: fileSelectController)

        present(fileSelectController, animated: true, completion: nil)
    }

    func loadButtonPressed(_ button: UIButton, currentViewController: UIViewController) {
        self.currentViewController = currentViewController
        if let fileSelectController = createFileSelectController(button: button,
                                                                 fileAction: loadBubblesAndPlay) {
            currentViewController.present(fileSelectController, animated: true, completion: nil)
        }
    }

    func loadBubblesAndPlay(file: URL, currentViewController: UIViewController) {
        self.currentViewController = currentViewController
        performFileAction(file, fileAction: loadBubblesAndPlay)
    }

    private func loadBubblesAndPlay(file: URL) throws {
        try loadFromFile(file)

        guard let playViewController = storyboard?
                                       .instantiateViewController(withIdentifier:
                                                                  Constants.StoryBoardID.PlayViewController)
                                                                                 as? PlayViewController else {
            fatalError("Failed to instantiate PlayViewController")
        }
        playViewController.gridBubbles = gridBubbles
        (currentViewController ?? self).present(playViewController, animated: true, completion: nil)
    }

    @IBAction private func loadButtonPressed(_ button: UIButton) {
        if let fileSelectController = createFileSelectController(button: button,
                                                                 fileAction: loadFromFile) {
            present(fileSelectController, animated: true, completion: nil)
        }
    }

    @IBAction private func resetButtonPressed(_ button: UIButton) {
        delegate?.gridBubbles.bubbles.removeAll()
        delegate?.updateAllCells()
    }

    private func getFileSelectAction(file: URL,
                                     fileAction: @escaping (URL) throws -> Void,
                                     button: UIButton) -> UIAlertAction {
        var style = UIAlertActionStyle.default
        if let lastFile = lastFileAccessed {
            if FileHandler.getFileName(file) == FileHandler.getFileName(lastFile) {
                style = .destructive
            }
        }
        return UIAlertAction(title: FileHandler.getFileName(file), style: style) { _ in
            self.performFileAction(file, fileAction: fileAction)
            button.isSelected = false
        }
    }

    private func performFileAction(_ file: URL, fileAction: @escaping (URL) throws -> Void) {
        do {
            try fileAction(file)
        } catch let fileError as FileError {
            displayError(fileError)
        } catch {
            displayError(error)
        }
    }

    private func createFileSelectController(button: UIButton,
                                            fileAction: @escaping (URL) throws -> Void)
                                                                  -> UIAlertController? {
        button.isSelected = true
        guard let files = tryGetSavedFiles() else {
            button.isSelected = false
            return nil
        }

        let fileSelectController = UIAlertController(title: "Choose file",
                                                     message: nil,
                                                     preferredStyle: .actionSheet)
        fileSelectController.popoverPresentationController?.sourceView = button

        for file in files {
            fileSelectController.addAction(getFileSelectAction(file: file,
                                                               fileAction: fileAction,
                                                               button: button))
        }

        addCancelAction(controller: fileSelectController, button: button)

        return fileSelectController
    }

    private func addCancelAction(controller: UIAlertController, button: UIButton? = nil) {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            button?.isSelected = false
        }
        controller.addAction(cancelAction)
    }

    private func checkIfFileNameValid(_ fileName: String) throws {
        if fileName.contains("/") {
            throw FileError.invalidFileName(fileName)
        }
    }

    func tryGetSavedFiles() -> [URL]? {
        do {
            return try FileHandler.getSavedFiles()
        } catch let fileError as FileError {
            displayError(fileError)
        } catch {
            displayError(error)
        }
        return nil
    }

    private func displayError(_ error: Error) {
        let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription,
                                           preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        presentedViewController?.dismiss(animated: true, completion: nil)
        (currentViewController ?? self).present(errorAlert, animated: true, completion: nil)
    }

    fileprivate func saveToNewFile(_ fileName: String) {
        do {
            try checkIfFileNameValid(fileName)
            try checkIfFileExistsAndSave(fileName)
        } catch let fileError as FileError {
            displayError(fileError)
        } catch {
            displayError(error)
        }
    }

    private func checkIfFileExistsAndSave(_ fileName: String) throws {
        let fileURL = try FileHandler.getFileURL(fileName)

        for file in try FileHandler.getSavedFiles() {
            if FileHandler.getFileName(file) != fileName {
                continue
            }

            let fileExistsAlert = UIAlertController(title: "File already exists", message: nil,
                                                    preferredStyle: .alert)
            addCancelAction(controller: fileExistsAlert)

            let overwriteAction = UIAlertAction(title: "Overwrite", style: .destructive) { _ in
                self.performFileAction(fileURL, fileAction: self.saveToFile)
            }
            fileExistsAlert.addAction(overwriteAction)

            presentedViewController?.dismiss(animated: true, completion: nil)
            present(fileExistsAlert, animated: true, completion: nil)
            return
        }

        try saveToFile(fileURL)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

    private func saveToFile(_ file: URL) throws {
        lastFileAccessed = file

        let bubbles = NSMutableDictionary()
        delegate?.gridBubbles.bubbles.forEach { index, bubble in
            bubbles[String(index)] = bubble.type.rawValue
        }

        if !bubbles.write(to: file, atomically: true) {
            throw FileError.failToWrite(fileName: FileHandler.getFileName(file))
        }
    }

    private func loadFromFile(_ file: URL) throws {
        lastFileAccessed = file

        guard let bubbles = NSDictionary(contentsOf: file) as? [String: Int] else {
            throw FileError.failToLoadFile(fileName: FileHandler.getFileName(file))
        }

        for (indexStr, bubbleTag) in bubbles {
            guard let index = Int(indexStr) else {
                throw FileError.indexNotInt(indexStr: indexStr)
            }
            guard let button = BubbleType(rawValue: bubbleTag) else {
                throw FileError.wrongTag(tag: bubbleTag)
            }
            guard var bubble = Bubble(type: button) else {
                throw FileError.wrongTag(tag: bubbleTag)
            }
            if let normalBubble = NormalBubble(type: button) {
                bubble = normalBubble
            }
            gridBubbles.add(at: index, bubble: bubble)
        }

        delegate?.gridBubbles = gridBubbles
        delegate?.updateAllCells()
    }

}
