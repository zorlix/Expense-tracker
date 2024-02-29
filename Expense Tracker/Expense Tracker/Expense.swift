//
//  Expense.swift
//  Expense Tracker
//
//  Created by Josef Černý on 28.02.2024.
//

import Foundation
import SwiftData

@Model
class Expense {
    var id = UUID()
    var name: String
    var amount: Int
    var type: String = "expense"
    var date: Date = Date.now
    
    init(id: UUID = UUID(), name: String, amount: Int, type: String, date: Date) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.date = date
    }
}
