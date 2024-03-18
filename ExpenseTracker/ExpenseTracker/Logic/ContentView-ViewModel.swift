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
            } catch {
                print("Failed to save to documents directory: \(error.localizedDescription)")
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
        
        // Navigation
        var path = NavigationPath()
        
        // Calculations Class for Counting View
        var calculations = Counting()
        
        // Logic
        func sort() {
            expenses.sort()
        }
        
        func newExpense() {
            let newExpense = Expense(id: UUID(), item: "", type: "Expense", amount: 0, date: .now)
            expenses.append(newExpense)
            path.append(newExpense)
            save()
            sort()
        }
        
        func saveReturned(original: Expense, incoming: Expense) {
            if let index = expenses.firstIndex(of: original) {
                if original.id == incoming.id {
                    expenses.remove(at: index)
                } else {
                    expenses[index] = incoming
                }
            }
            save()
            sort()
        }
        
        func deleteWithSwipe(at offsets: IndexSet) {
            for offset in offsets {
                expenses.remove(at: offset)
                save()
            }
        }
        
        func removeAll() {
            expenses.removeAll()
            save()
        }
        
        // Debug
        #if DEBUG
        func test() {
            let example1 = Expense(id: UUID(), item: "Lunch", type: "Expense", amount: 150, date: .now)
            let example2 = Expense(id: UUID(), item: "Money back", type: "Income", amount: 300, date: .now.addingTimeInterval(-86400))
            expenses.append(example1)
            expenses.append(example2)
            save()
            sort()
        }
        #endif
    }
}
