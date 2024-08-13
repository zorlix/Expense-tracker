//
//  TrackerOfTrackers.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import Foundation

    @Observable
    class TrackerOfTrackers: Identifiable, Codable, Equatable, Hashable, Comparable {
        var id: UUID
        var name: String
        var trackers: [TrackerOfItems]
        
        static func ==(lhs: TrackerOfTrackers, rhs: TrackerOfTrackers) -> Bool {
            lhs.id == rhs.id
        }
        
        static func <(lhs: TrackerOfTrackers, rhs: TrackerOfTrackers) -> Bool {
            lhs.name < rhs.name
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        init(id: UUID = UUID(), name: String, trackers: [TrackerOfItems]) {
            self.id = id
            self.name = name
            self.trackers = trackers
        }
    }
