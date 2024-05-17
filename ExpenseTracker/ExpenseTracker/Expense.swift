//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Zorlix on 17.03.2024.
//

import Foundation

struct Expense: Identifiable, Codable, Equatable, Hashable, Comparable {
    var id: UUID
    var item: String
    var type: String
    var amount: Int
    var defaultExpense: DefaultExpense?
    var date: Date
    
    
    static func ==(lhs: Expense, rhs: Expense) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Expense, rhs: Expense) -> Bool {
        lhs.date > rhs.date
    }
    
    #if DEBUG
    static let example = Expense(id: UUID(), item: "Test Item", type: "Expense", amount: 123, date: .now)
    #endif
}
