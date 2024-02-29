//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Expense.date) var expenses: [Expense]
    
    @State private var showingAddExpenseView = false
    @State private var isTestViewActive = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.name)
                                .font(.headline)
                            Text(expense.date, format: .dateTime.day().month().year())
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(expense.amount, format: .currency(code: "CZK"))
                            .foregroundStyle(expense.type == "expense" ? .red : .green)
                    }
                }
                .onDelete(perform: deleteExpense)
            }
            .navigationTitle("Expense Tracker")
            .toolbar {
                ToolbarItem {
                    Button("Test") {
                        let tempExpense = Expense(name: "Lunch", amount: 123, type: "expense", date: Date.now)
                        modelContext.insert(tempExpense)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpenseView = true
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        YearView()
                    } label: {
                        Image(systemName: "square.2.layers.3d.bottom.filled")
                    }
                }
            }
            .sheet(isPresented: $showingAddExpenseView) {
                AddExpenseView()
            }
        }
    }
    
    func deleteExpense(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
}

#Preview {
    ContentView()
}
