//
//  Tracking.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import Foundation

@Observable
class Tracking {
    var items: [Tracker]
    
    func trimUnneeded() {
        for item in items {
            if item.name.isEmpty {
                if let index = items.firstIndex(of: item) {
                    items.remove(at: index)
                }
            }
        }
        
        save()
    }
    
    let savePath = URL.documentsDirectory.appending(path: "trackers.json")
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(items)
            try encoded.write(to: savePath)
            print("Saved trackers.")
        } catch {
            print("Failed to save trackers: \(error.localizedDescription)")
        }
    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Tracker].self, from: data)
            items = decoded
            print("Decoded trackers.")
        } catch {
            items = []
            print("Failed to decode trackers: \(error.localizedDescription)")
        }
    }
}
