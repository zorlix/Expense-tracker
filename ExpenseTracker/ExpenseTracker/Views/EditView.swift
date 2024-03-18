//
//  EditView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    var onSave: (Expense) -> Void
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        Form {
            Section("Item") {
                TextField("Item", text: $viewModel.item)
            }
            
            Section("Type") {
                Picker("Type", selection: $viewModel.type) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.segmented)
            }
            
            Section("Amount") {
                HStack {
                    TextField("Amount", value: $viewModel.amount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    Spacer()
                    Text("CZK")
                }
            }
            
            Section {
                DatePicker("Date", selection: $viewModel.date)
            }
            
            Section {
                Button("Save") {
                    onSave(viewModel.saveExpense())
                    dismiss()
                }
                
                Button("Delete") {
                    onSave(viewModel.expense)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Expense")
        .toolbar {
            Button("Done") { isFocused = false }
        }
    }
    
    init(expense: Expense, onSave: @escaping (Expense) -> Void) {
        self.onSave = onSave
        
        _viewModel = State(initialValue: ViewModel(expense: expense, item: expense.item, type: expense.type, amount: expense.amount, date: expense.date))
    }
}

#Preview {
    EditView(expense: .example) { _ in }
}
