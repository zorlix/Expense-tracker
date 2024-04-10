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
            Picker("Default", selection: $viewModel.expense.defaultExpense) {
                Text("Custom").tag(nil as DefaultExpense?)
                if viewModel.expense.defaultExpense == nil {
                    Text("Default").tag(viewModel.defaults.defaults.first)
                } else {
                    Text("Default").tag(viewModel.expense.defaultExpense)
                }
            }
            .pickerStyle(.segmented)
            
            if viewModel.expense.defaultExpense != nil {
                Picker("Defaults", selection: $viewModel.expense.defaultExpense) {
                    Text("None").tag(nil as DefaultExpense?)
                    ForEach(viewModel.defaults.defaults) { item in
                        Text(item.item).tag(Optional(item))
                    }
                }
                
                Section("Default values") {
                    HStack {
                        Text("Name:").bold()
                        Text(viewModel.expense.defaultExpense?.item ?? "")
                    }
                    
                    HStack {
                        Text("Type:").bold()
                        Text(viewModel.expense.defaultExpense?.type ?? "")
                    }
                }
            } else {
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
            if isFocused {
                Button("Done") { isFocused = false }
            }
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
