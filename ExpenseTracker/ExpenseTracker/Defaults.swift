//
//  Defaults.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import Foundation

class Default: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id = UUID()
    var name: String
    var type: String
    
    static func ==(lhs: Default, rhs: Default) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Default, rhs: Default) -> Bool {
        lhs.name < rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
class Defaults {
    var items: [Default]
    
    let savePath = URL.documentsDirectory.appending(path: "defaults.json")
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(items)
            try encoded.write(to: savePath)
            print("Saved default")
        } catch {
            print("Failed to save default (\(error.localizedDescription)).")
        }
    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Default].self, from: data)
            items = decoded
            print("Decoded dafaults.")
        } catch {
            items = []
            print("Failed to decode defaults (\(error.localizedDescription)).")
        }
    }
}
