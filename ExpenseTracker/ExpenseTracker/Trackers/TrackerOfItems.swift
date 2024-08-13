//
//  Tracker.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import Foundation

@Observable
class TrackerOfItems: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var name: String
    var trackingStrings: [String]
    var total: Bool
    var oldAmount: Int
    
    static func ==(lhs: TrackerOfItems, rhs: TrackerOfItems) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: TrackerOfItems, rhs: TrackerOfItems) -> Bool {
        lhs.name < rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: UUID = UUID(), name: String, trackingStrings: [String], total: Bool, oldAmount: Int = 0) {
        self.id = id
        self.name = name
        self.trackingStrings = trackingStrings
        self.total = total
        self.oldAmount = oldAmount
    }
}

