//
//  Multiples.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.04.2024.
//

import Foundation

struct Multiple: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var name: String
    var defaults: [DefaultExpense]
    
    static func ==(lhs: Multiple, rhs: Multiple) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Multiple, rhs: Multiple) -> Bool {
        lhs.name < rhs.name
    }
}

@Observable
class Multiples {
    var items: [Multiple]
    
    let savePath = URL.documentsDirectory.appending(path: "Multiples")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Multiple].self, from: data)
            items = decoded
        } catch {
            items = []
        }
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(items)
            try encoded.write(to: savePath)
        } catch {
            print("Failed to save items: \(error.localizedDescription)")
        }
    }
    
    func delete(item: Multiple) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
