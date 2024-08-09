//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var path = NavigationPath()
    @State private var showingSettigns = false
    
    var total: Int {
        let fetchDescriptor = FetchDescriptor<Expense>()
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return 0 }
        
        var outcome = 0
        var income = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        return income - outcome
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ExpensesView()
                .navigationTitle("Expense Tracker")
                .sheet(isPresented: $showingSettigns) {
                    SettingsView()
                        .presentationDetents([.medium, .large])
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Settings", systemImage: "gear") {
                            showingSettigns = true
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add expense", systemImage: "plus", action: addExpense)
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Text("Total:")
                                .bold()
                            
                            Text(total, format: .currency(code: "CZK"))
                                .foregroundStyle(total > 0 ? .green : .red)
                        }
                    }
                }
        }
    }
    
    func addExpense() {
        let newExpense = Expense(item: "", type: "Expense", amount: 0, date: .now)
        modelContext.insert(newExpense)
        path.append(newExpense)
    }
}

