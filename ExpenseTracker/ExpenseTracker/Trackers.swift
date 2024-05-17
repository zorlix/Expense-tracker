//
//  Trackers.swift
//  ExpenseTracker
//
//  Created by Zorlix on 20.03.2024.
//

import Foundation

enum Tracker: Hashable, Codable {
    case combination(Combination)
    case operation(Operation)
}

extension Tracker {
    var id: UUID {
        switch self {
        case .combination(let combination):
            return combination.id
        case .operation(let operation):
            return operation.id
        }
    }
    
    var name: String {
        switch self {
        case .combination(let combination):
            return combination.name
        case .operation(let operation):
            return operation.name
        }
    }
}

struct Combination: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var name: String
    var trackedDefaults: [DefaultExpense]
    var total: Bool
    
    static func ==(lhs: Combination, rhs: Combination) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Combination, rhs: Combination) -> Bool {
        lhs.name < rhs.name
    }
}

struct Operation: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var name: String
    var description: String?
    var trackedCombinations: [Combination]
    
    static func ==(lhs: Operation, rhs: Operation) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Operation, rhs: Operation) -> Bool {
        lhs.name < rhs.name
    }
}
