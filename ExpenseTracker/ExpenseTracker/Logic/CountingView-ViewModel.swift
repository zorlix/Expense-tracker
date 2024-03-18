//
//  CountingView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import Foundation

extension CountingView {
    @Observable
    class ViewModel {
        var expenses: [Expense]
        var counting: Counting
        
        func calculate() {
            counting.annul()
            var tempIncome = 0
            var tempOutcome = 0
            
            for expense in expenses {
                if expense.date < counting.startingDate {
                    if expense.type == "Expense" {
                        tempOutcome += expense.amount
                    } else if expense.type == "Income" {
                        tempIncome += expense.amount
                    }
                } else if expense.date > counting.startingDate && expense.date < counting.endingDate {
                    counting.loaded.append(expense)
                    if expense.type == "Expense" {
                        counting.outcome += expense.amount
                    } else if expense.type == "Income" {
                        counting.income += expense.amount
                    }
                }
            }
            
            counting.balancePrior = tempIncome - tempOutcome
            counting.balaneDuring = counting.income - counting.outcome
            counting.balance = counting.balancePrior + counting.balaneDuring
            counting.finished = true
        }
        
        init(expenses: [Expense], counting: Counting) {
            self.expenses = expenses
            self.counting = counting
        }
    }
}
