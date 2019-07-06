//
//  FileIO.swift
//  Activity Tracker
//
//  Created by System Administrator on 7/5/19.
//  Copyright © 2019 Pramod Kotipalli. All rights reserved.
//

import Foundation

class FileIO {
    private let fileURL: URL
    init(_ fileURL: URL) {
        self.fileURL = fileURL
    }
    
    func write(_ text: String) -> Bool {
        do {
            try text.appendLineToURL(fileURL: self.fileURL)
        }
        catch {
            return false
        }
        return true
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}

