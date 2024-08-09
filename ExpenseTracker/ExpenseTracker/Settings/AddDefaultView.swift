//
//  AddDefaultView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 09.08.2024.
//

import SwiftUI

struct AddDefaultView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var defaults: Defaults
    
    @State private var name = ""
    @State private var type = "Expense"
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    Text("Expense").tag("Expense")
                    Text("Income").tag("Income")
                }
                .pickerStyle(.segmented)
            }
            
            Section {
                Button("Add Default") {
                    let newDef = Default(name: name, type: type)
                    defaults.items.insert(newDef, at: 0)
                    defaults.save()
                    dismiss()
                }
            }
        }
        .navigationTitle("Add Default")
        .navigationBarTitleDisplayMode(.inline)
    }
}
