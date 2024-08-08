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
    @Query(sort: \Expense.date, order: .reverse) var expenses: [Expense]
    
    @State private var path = NavigationPath()
    
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
            List {
                ForEach(expenses) { expense in
                    NavigationLink(value: expense) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(expense.item)
                                    .font(.headline)
                                
                                Text(expense.date, format: .dateTime.day().month().year())
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Text(expense.amount, format: .currency(code: "CZK"))
                                .foregroundStyle(expense.type == "Expense" ? .red : .green)
                        }
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .navigationTitle("Expense Tracker")
            .navigationDestination(for: Expense.self) { expense in
                ExpenseEditView(expense: expense)
            }
            .toolbar {
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
    
    func deleteExpense(at indexSet: IndexSet) {
        for index in indexSet {
            let toDel = expenses[index]
            modelContext.delete(toDel)
        }
    }
}

