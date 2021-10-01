//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/09/17.
//

import Foundation
import SwmCore

public struct Storage {
    private let storage: SwmCore.Storage
    
    public init(dir: String) throws {
        self.storage = SwmCore.Storage(dir: dir)
        try storage.prepare()
    }
    
    func absolutePath(_ name: String) -> String {
        "\(storage.dir)/\(name).json"
    }
    
    func exists(_ name: String) -> Bool {
        let file = "\(name).json"
        return storage.exists(name: file)
    }
    
    func load(_ name: String) -> Result? {
        if exists(name) {
            let file = "\(name).json"
            return try? storage.loadJSON(name: file)
        } else {
            return nil
        }
    }

    func save(_ name: String, _ str: Result) {
        let file = "\(name).json"
        try! storage.saveJSON(name: file, object: str)
    }
    
    func delete(_ name: String) {
        if exists(name) {
            let file = "\(name).json"
            try! storage.delete(file)
        }
    }
}
