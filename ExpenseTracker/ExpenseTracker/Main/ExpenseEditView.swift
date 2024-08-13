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
    
    @FocusState private var textFieldFocused: Bool
    var formattedAmountNumber: String  {
        Formatter.textFieldZeroFormat.string(from: NSNumber(value: expense.amount)) ?? "Eh"
    }
    
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
               TextField("Amount", value: $expense.amount, formatter: Formatter.textFieldZeroFormat)
                   .keyboardType(.decimalPad)
                   .focused($textFieldFocused)
               Text("Amount: \(expense.amount)")
               Text("Formatted: \(formattedAmountNumber)")
            }
            
            Section {
                DatePicker("Date", selection: $expense.date)
            }
        }
        .navigationTitle("Edit Expense")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Delete expense", systemImage: "trash", action: deleteExpense)
            
            if textFieldFocused {
                Button("Done") {
                    textFieldFocused = false
                }
            }
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }
    
    func deleteExpense() {
        modelContext.delete(expense)
        dismiss()
    }
}


