//
//  FileHandler.swift
//  BubbleMania
//
//  Created by riwu on 21/2/17.
//  Copyright © 2017 nus.cs3217.a0135766w. All rights reserved.
//

import Foundation

class FileHandler {

    static func getFileName(_ file: URL) -> String {
        return file.deletingPathExtension().lastPathComponent
    }

    static func getSavedFiles() throws -> [URL] {
        let documentDirectory = try getDocumentDirectory()
        let files = try FileManager.default.contentsOfDirectory(at: documentDirectory,
                                                                includingPropertiesForKeys: nil,
                                                                options:[])
        return files.filter {
            $0.pathExtension.lowercased() == Constants.File.fileExtension
        }
    }

    static func getFileURL(_ fileName: String) throws -> URL {
        let documentDirectory = try getDocumentDirectory()
        return documentDirectory.appendingPathComponent(fileName + "." + Constants.File.fileExtension)
    }

    private static func getDocumentDirectory() throws -> URL {
        guard let result = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first else {
            throw FileError.failToRetrieveDocumentDirectory
        }
        return result
    }

}
