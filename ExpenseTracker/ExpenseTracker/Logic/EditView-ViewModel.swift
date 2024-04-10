//
//  EditView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import Foundation
import SwiftUI

extension EditView {
    @Observable
    class ViewModel {
        var expense: Expense
        
        var item: String
        var type: String
        var amount: Int
        var date: Date
        
        private(set) var defaults = Defaults()
                
        func saveExpense() -> Expense {
            var tempExpense = expense
            tempExpense.id = UUID()
            if let defaultSelected = expense.defaultExpense {
                tempExpense.item = defaultSelected.item
                tempExpense.type = defaultSelected.type
            } else {
                tempExpense.item = item
                tempExpense.type = type
            }
            tempExpense.amount = amount
            tempExpense.date = date
            return tempExpense
        }
        
        init(expense: Expense, item: String, type: String, amount: Int, date: Date, defaults: Defaults = Defaults()) {
            self.expense = expense
            self.item = item
            self.type = type
            self.amount = amount
            self.date = date
            self.defaults = defaults
            
            print("Edit")
        }
    }
}
