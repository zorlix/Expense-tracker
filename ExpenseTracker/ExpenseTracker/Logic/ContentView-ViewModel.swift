//
//  ContentView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import Foundation
import SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        // Main expenses array
        private(set) var expenses = [Expense]()
        
        // Save and load data
        let savePath = URL.documentsDirectory.appending(path: "expenses.json")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                let decoded = try JSONDecoder().decode([Expense].self, from: data)
                expenses = decoded
            } catch {
                expenses = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(expenses)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
                print("Saved")
            } catch {
                print("Failed to save to documents directory: \(error.localizedDescription)")
            }
        }
        
        // Migrate
        func migrate(old: DefaultExpense, new: String, type: String) {
            let  defaults = Defaults()
            
            let newDefault = DefaultExpense(id: UUID(), item: new, type: type)
            if let index = defaults.defaults.firstIndex(of: old) {
                defaults.defaults[index] = newDefault
            }
            defaults.save()
            
            if expenses.isEmpty == false {
                for expense in expenses {
                    if expense.item == old.item {
                        let newExpense = Expense(id: UUID(), item: new, type: type, amount: expense.amount, defaultExpense: newDefault, date: expense.date)
                        if let index = expenses.firstIndex(of: expense) {
                            expenses[index] = newExpense
                        }
                    }
                }
                
                save()
            }
        }
        
        // Import data
        var importFile = false
        
        func importData(from file: URL) {
            if file.startAccessingSecurityScopedResource() {
                defer { file.stopAccessingSecurityScopedResource() }
                do {
                    let data = try Data(contentsOf: file)
                    let decoded = try JSONDecoder().decode([Expense].self, from: data)
                    expenses = decoded
                    save()
                } catch {
                    print("Failed to load data from file: \(error.localizedDescription)")
                }
            }
        }
        
        // Total
        var total: Int {
            var exp = 0
            var inc = 0
            
            for expense in expenses {
                if expense.type == "Expense" {
                    exp += expense.amount
                } else if expense.type == "Income" {
                    inc += expense.amount
                }
            }
            
            return inc - exp
        }
        
        // Navigation
        var navig = Navigation()
        
        // Calculations Class for Counting View
        var calculations = Counting()
        
        // Multiples (multiple entries)
        var multiples = Multiples()
        
        // Logic
        func sort() {
            expenses.sort()
        }
        
        func newExpense() {
            let newExpense = Expense(id: UUID(), item: "", type: "Expense", amount: 0, date: .now)
            expenses.append(newExpense)
            navig.path.append(newExpense)
            save()
            sort()
        }
        
        func saveReturned(original: Expense, incoming: Expense) {
            if let index = expenses.firstIndex(of: original) {
                if original.id == incoming.id || incoming.item.isEmpty {
                    expenses.remove(at: index)
                } else {
                    expenses[index] = incoming
                }
            }
            save()
            sort()
        }
        
        func saveMultiple(_ array: [Expense]) {
            for item in array {
                expenses.append(item)
            }
            save()
            sort()
        }
        
        func saveDescipancy(from expense: Expense) {
            expenses.append(expense)
            save()
            sort()
        }
        
        func deleteWithSwipe(at offsets: IndexSet) {
            for offset in offsets {
                expenses.remove(at: offset)
                save()
            }
        }
        
        func checkForEmpty() {
            for expense in expenses {
                if expense.item.isEmpty {
                    if let index = expenses.firstIndex(of: expense) {
                        expenses.remove(at: index)
                    }
                }
            }
        }
        
        func removeAll() {
            expenses.removeAll()
            save()
        }
    }
}
