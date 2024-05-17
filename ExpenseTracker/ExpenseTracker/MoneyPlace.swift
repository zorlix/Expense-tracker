//
//  MoneyPlace.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 12.04.2024.
//

import Foundation

@Observable
class MoneyPlaces {
    var places: [String] = []
    
    let savePath = URL.documentsDirectory.appending(path: "Money Places")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([String].self, from: data)
            places = decoded
        } catch {
            places = []
        }
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(places)
            try encoded.write(to: savePath)
        } catch {
            print("Failed to save places: \(error.localizedDescription)")
        }
    }
    
    func deletePlace(_ place: String) {
        if let index = places.firstIndex(of: place) {
            places.remove(at: index)
        }
    }
}
