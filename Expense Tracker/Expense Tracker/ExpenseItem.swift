//
//  ExpenseItem.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let date: Int
    let amount: Int
    let item: String
}

@Observable
class Expenses {
    var items = [ExpenseItem]()
}
