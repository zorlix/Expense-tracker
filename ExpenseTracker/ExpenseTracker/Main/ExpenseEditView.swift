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
    @State private var selectedDefault: Default?
    
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        Form {
            Section { // First picker between Custom and Default
                Picker("Custom expense or default?", selection: $selectedDefault) {
                    Text("Custom").tag(Optional<Default>.none)
                    if selectedDefault == nil {
                        Text("Default").tag(defaults.items.first)
                    } else {
                        Text("Default").tag(selectedDefault)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedDefault, changeDefault)
                .onAppear(perform: resolveDefault)
            }
            
            if selectedDefault != nil {   // Default options
                Section {
                    Picker("Defaults", selection: $selectedDefault) {
                        Text("None").tag(Optional<Default>.none)
                        ForEach(defaults.items) { defaultItem in
                            Text(defaultItem.name).tag(Optional(defaultItem))
                                .foregroundStyle(defaultItem.type == "Expense" ? .red : .green)
                        }
                    }
                }
                
                Section("Defaults") {
                    HStack {
                        Text("Item:")
                            .bold()
                        
                        Text(expense.item)
                    }
                    
                    HStack {
                        Text("Type:")
                            .bold()
                        
                        Text(expense.type)
                    }
                }
            } else { // Custom expense/income
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
                
                Section {
                    Button("Save current as default", action: addDefault)
                }
            }
            
           Section("Amount") {  // Amount text field
               HStack {
                   TextField("Amount", value: $expense.amount, format: .currency(code: "CZK"))
                       .keyboardType(.decimalPad)
                       .focused($textFieldFocused)
                       .onAppear {
                           UITextField.appearance().clearButtonMode = .whileEditing
                       }
                   
                   if textFieldFocused {
                       Button("Submit") {
                           textFieldFocused = false
                       }
                   }
               }
            }
            
           
            Section {  // Date selection
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
    
    func changeDefault() { // run after tapping the first picker (custom or default)
        if let selected = selectedDefault {
            expense.item = selected.name
            expense.type = selected.type
        }
    }
    
    func resolveDefault() { // run on appear of the whole view
        for item in defaults.items {
            if expense.item == item.name && expense.type == item.type {
                selectedDefault = item
            }
        }
    }
    
    func addDefault() {
        let def = Default(name: expense.item, type: expense.type)
        defaults.saveDefault(def)
        selectedDefault = def
    }
}


