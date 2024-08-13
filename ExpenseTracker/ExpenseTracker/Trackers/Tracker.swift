//
//  Tracker.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import Foundation

enum Tracker: Hashable, Codable {
    case trackerOfItems(TrackerOfItems)
    case trackerOfTrackers(TrackerOfTrackers)
}

extension Tracker {
    var id: UUID {
        switch self {
        case .trackerOfItems(let toi):
            return toi.id
        case .trackerOfTrackers(let tot):
            return tot.id
        }
    }
    
    var name: String {
        switch self {
        case .trackerOfItems(let toi):
            return toi.name
        case .trackerOfTrackers(let tot):
            return tot.name
        }
    }
}
