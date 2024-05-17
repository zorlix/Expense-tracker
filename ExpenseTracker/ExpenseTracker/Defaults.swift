//
//  Defaults.swift
//  ExpenseTracker
//
//  Created by Zorlix on 19.03.2024.
//

import Foundation

struct DefaultExpense: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var item: String
    var type: String
    
    static func ==(lhs: DefaultExpense, rhs: DefaultExpense) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: DefaultExpense, rhs: DefaultExpense) -> Bool {
        lhs.item < rhs.item
    }
}

@Observable class Defaults {
    var defaults = [DefaultExpense]()
    
    let savePath = URL.documentsDirectory.appending(path: "defaults.json")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([DefaultExpense].self, from: data)
            defaults = decoded
        } catch {
            defaults = []
        }
        
        print("Initializing Defaults")
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(defaults)
            try encoded.write(to: savePath)
        } catch {
            print("Failed to save defaults: \(error.localizedDescription)")
        }
    }
    
    func delete(item: DefaultExpense) {
        if let index = defaults.firstIndex(of: item) {
            defaults.remove(at: index)
            save()
        }
    }
}
