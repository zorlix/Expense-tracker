//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import Foundation
import SwiftData

@Model
class Expense {
    var item: String
    var type: String
    var amount: Int
    var date: Date
    
    init(item: String, type: String, amount: Int, date: Date) {
        self.item = item
        self.type = type
        self.amount = amount
        self.date = date
    }
}

