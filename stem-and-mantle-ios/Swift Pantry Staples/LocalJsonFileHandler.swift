//
//  LocalJsonFileHandler.swift
//  GenUI's Swift Pantry Staples
//
//  Created by Rob Busack on 7/29/2020
//  Copyright © 2020 Rob Busack. All rights reserved.
//

import Foundation

let MY_DIRECTORY_FOR_SAVE_DATA = "persistentData"

class LocalJsonFileHandler<T:Codable>: NSObject {
    
    let filename: String    // just some simple name (a .json extension will be automatically added to this
    let contentType: T.Type
    
    // MARK: Public Interface
    init(_ filename: String, _ contentType: T.Type) {
        self.filename = filename
        self.contentType = contentType
    }
    
    func load() -> T? {
        return LocalJsonFileHandler.load(filename: filename, jsonObjectType: contentType)
    }
    
    func save(_ newVersion: T) {
        LocalJsonFileHandler.save(filename: filename, jsonObject: newVersion)
    }
    
    func erase() {
        LocalJsonFileHandler.erase(filename: filename)
    }
    
    // MARK: Private stuff under the hood
    
    static func urlForFilename(_ filename: String) -> URL? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let filenameWithExtension = filename + ".json"
            let myDirectory = documentsDirectory.appendingPathComponent(MY_DIRECTORY_FOR_SAVE_DATA)
            
            // make sure our directory exists, if it does not already
            try? FileManager.default.createDirectory(at: myDirectory, withIntermediateDirectories: true, attributes: nil)
            
            let fileUrl = myDirectory.appendingPathComponent(filenameWithExtension)
            return fileUrl
        } else {
            print("For some reason we can't access the documents directory")
            return nil
        }
    }
    
    static func load<T:Codable>(filename: String, jsonObjectType: T.Type) -> T? {
        guard let urlForFile = self.urlForFilename(filename) else {
            print("Couldn't generate URL for file \(filename)")
            return nil
        }
        
        do {
            let fileAsData = try Data(contentsOf: urlForFile)
            let object = try JSONDecoder().decode(T.self, from: fileAsData)
            return object
        } catch CocoaError.fileReadNoSuchFile {
            // no worries!
            return nil
        } catch {
            print("Error while loading file \(filename): \(error)")
        }
        
        return nil
    }
    
    static func save<T:Codable>(filename: String, jsonObject: T) {
        guard let urlForFile = self.urlForFilename(filename) else {
            print("Couldn't generate URL for file \(filename)")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(jsonObject)
            try data.write(to: urlForFile, options: .atomic)
            
        } catch {
            print("Error while saving file \(filename): \(error)")
        }
        
    }
    
    static func erase(filename: String) {
        guard let urlForFile = self.urlForFilename(filename) else {
            print("Couldn't generate URL for file \(filename)")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: urlForFile)
        } catch {
            print("This probably doesn't matter: Deleting file \(filename) failed because of \(error)")
        }
    }
}
