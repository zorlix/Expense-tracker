//
//  MigrateDefaultsView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 16.04.2024.
//

import SwiftUI

struct MigrateDefaultsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var defaults = Defaults()
    
    @State private var selectedExpense: DefaultExpense?
    @State private var newName = ""
    @State private var newType = "Expense"
    
    @State private var showingAlert = false
    
    var onClose: (String, String, DefaultExpense) -> Void
    
    var body: some View {
        Form {
            Section("Default Expense") {
                Picker("Default Expense", selection: $selectedExpense) {
                    Text("None").tag(nil as DefaultExpense?)
                    ForEach(defaults.defaults) { def in
                        Text(def.item).tag(Optional(def))
                    }
                }
            }
            
            Section("New shit") {
                TextField("Name", text: $newName)
                Picker("Type", selection: $newType) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Button("Migrate") {
                    guard let selectedExpense = selectedExpense else { showingAlert = true; return }
                    
                    let name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                    let type = newType.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if name.isEmpty { showingAlert = true; return }
                    if type.isEmpty { showingAlert = true; return }
                    
                    onClose(name, type, selectedExpense)
                    dismiss()
                }
            }
        }
        .navigationTitle("Migrate Expenses")
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", action: {})
        } message: {
            Text("You must select a default and pick a new name.")
        }
    }
    
    init(onClose: @escaping (String, String, DefaultExpense) -> Void) {
        self.onClose = onClose
    }
}

