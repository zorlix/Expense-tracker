//
//  ExpenseEditView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import SwiftData
import SwiftUI

struct ExpenseEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @Bindable var expense: Expense
    
    @State private var defaults = Defaults()
    
    var body: some View {
        Form {
            Section("Item") {
                TextField("Item", text: $expense.item)
            }
            
            Section("Type") {
                Picker("Type", selection: $expense.type) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.segmented)
            }
            
            Section("Amount") {
                HStack {
                    TextField("Amount", value: $expense.amount, format: .number)
                    Text("CZK")
                }
            }
            
            Section {
                DatePicker("Date", selection: $expense.date)
            }
        }
        .navigationTitle("Edit Expense")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Delete expense", systemImage: "trash", action: deleteExpense)
        }
    }
    
    func deleteExpense() {
        modelContext.delete(expense)
        dismiss()
    }
}


