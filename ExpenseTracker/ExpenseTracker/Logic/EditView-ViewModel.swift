//
//  EditView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import Foundation

extension EditView {
    @Observable
    class ViewModel {
        var expense: Expense
        
        var item: String
        var type: String
        var amount: Int
        var date: Date
        
        func saveExpense() -> Expense {
            var tempExpense = expense
            tempExpense.id = UUID()
            tempExpense.item = item
            tempExpense.type = type
            tempExpense.amount = amount
            tempExpense.date = date
            return tempExpense
        }
        
        init(expense: Expense, item: String, type: String, amount: Int, date: Date) {
            self.expense = expense
            self.item = item
            self.type = type
            self.amount = amount
            self.date = date
        }
    }
}
