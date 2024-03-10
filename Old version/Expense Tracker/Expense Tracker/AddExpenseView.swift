//
//  AddExpenseView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 28.02.2024.
//

import SwiftUI

struct AddExpenseView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var amount = 0
    @State private var type = "expense"
    @State private var date = Date.now
    
    let types = ["expense", "income"]
    
    var isValid: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || amount == 0 {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Add expense name", text: $name)
                    
                    TextField("Insert amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker("Choose date", selection: $date)
                }
                
                Section {
                    Button("Save") {
                        let newExpense = Expense(name: name, amount: amount, type: type, date: date)
                        modelContext.insert(newExpense)
                        dismiss()
                    }
                }
                .disabled(isValid == false)
            }
            .navigationTitle("Add Expense")
        }
    }
}

#Preview {
    AddExpenseView()
}
