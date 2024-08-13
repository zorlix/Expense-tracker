//
//  DateSelectionView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 09.08.2024.
//

import SwiftData
import SwiftUI

struct DateSelectionView: View {
    @Environment(\.modelContext) var modelContext
    @Binding var limitDate: Bool
    @Binding var startingDate: Date
    @Binding var endingDate: Date
    
    var totalPrior: Int {
        var fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.date < startingDate
        })
        fetchDescriptor.propertiesToFetch = [\.date]
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return 0}
        
        var income = 0
        var outcome = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        return income - outcome
    }
    
    var incomeDuring: Int {
        var fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.date > startingDate && expense.date < endingDate
        })
        fetchDescriptor.propertiesToFetch = [\.date]
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return 0}
        
        var income = 0
        var outcome = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        return income
    }
    
    var expensesDuring: Int {
        var fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.date > startingDate && expense.date < endingDate
        })
        fetchDescriptor.propertiesToFetch = [\.date]
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return 0}
        
        var income = 0
        var outcome = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        return outcome
    }
    
    var balanceDuring: Int {
        return incomeDuring - expensesDuring
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Parameters") {
                    Toggle("Limit results to date", isOn: $limitDate)
                    
                    Group {
                        DatePicker("Starting Date", selection: $startingDate)
                        DatePicker("Ending Date", selection: $endingDate)
                    }
                    .disabled(limitDate == false)
                }
                
                Section("Data") {
                    Text("Balance prior to selection: \(totalPrior),-")
                    Text("Income in selection: \(incomeDuring),-")
                    Text("Expenses in selection: \(expensesDuring),-")
                    Text("Balance during selection: \(balanceDuring),-")
                }
            }
            .navigationTitle("Limit date")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
