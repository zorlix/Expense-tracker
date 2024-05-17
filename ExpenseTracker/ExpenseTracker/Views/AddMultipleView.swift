//
//  AddMultipleView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.04.2024.
//

import SwiftUI

struct AddMultipleView: View {
    @Environment(\.dismiss) var dismiss
    
    var multiple: Multiple
    
    @State private var defaults: [DefaultExpense]
    @State private var selectedDefaults = Set<DefaultExpense>()
    @State private var selectedDefaultsArray: [DefaultExpense] = []
    @State private var defaultValues = [Int]()
    
    @State private var showingSelection = false
    @State private var showDefaults = false
    @State private var showSelectedDefaults = false
    
    var onSave: ([Expense]) -> Void
    
    var body: some View {
        Form {
            Toggle("Show Defaults", isOn: $showDefaults)
            if showDefaults {
                Section("Defaults") {
                    ForEach(defaults) {
                        Text($0.item)
                    }
                }
            }
            
            Toggle("Show Selected Defaults", isOn: $showSelectedDefaults).disabled(selectedDefaultsArray.isEmpty)
            if showSelectedDefaults {
                Section("Selected Defaults") {
                    ForEach(selectedDefaultsArray) { item in
                        Text(item.item)
                    }
                }
            }
            
            if defaultValues.isEmpty == false {
                ForEach($defaultValues.indices, id: \.self) { index in
                    Section(selectedDefaultsArray[index].item) {
                        TextField("Amount", value: $defaultValues[index], format: .number)
                    }
                }
            }
            
            Button("Save") {
                var output: [Expense] = []
                
                for item in selectedDefaultsArray {
                    guard let index = selectedDefaultsArray.firstIndex(of: item) else { return }
                    let amount = defaultValues[index]
                    
                    let newExpense = Expense(id: UUID(), item: item.item, type: item.type, amount: amount, defaultExpense: item, date: .now)
                    
                    output.append(newExpense)
                }
                
                onSave(output)
                dismiss()
            }
            .disabled(checkValues())
        }
        .navigationTitle("Add Multiple")
        .onChange(of: selectedDefaults, selectedArray)
        .onChange(of: selectedDefaults, processTextFields)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Select defaults") {
                    showingSelection = true
                }
            }
        }
        .sheet(isPresented: $showingSelection) {
            SelectMultiple(defaults: $defaults, selectedDefaults: $selectedDefaults)
        }
    }
    
    init(multiple: Multiple, onSave: @escaping ([Expense]) -> Void) {
        self.multiple = multiple
        self.onSave = onSave
        
        _defaults = State(initialValue: multiple.defaults)
    }
    
    func selectedArray() {
        selectedDefaultsArray = Array(selectedDefaults)
    }
    
    func processTextFields() {
        defaultValues = []
        for _ in selectedDefaults {
            defaultValues.append(0)
        }
    }
    
    func checkValues() -> Bool {
        var result = false
        
        if defaultValues.isEmpty {
            result = true
        } else {
            for num in defaultValues {
                if num == 0 {
                    result = true
                    continue
                }
            }
        }
        
        return result
    }
}

struct SelectMultiple: View {
    @Environment(\.editMode) var editMode
    @Environment(\.dismiss) var dismiss
    @Binding var defaults: [DefaultExpense]
    @Binding var selectedDefaults: Set<DefaultExpense>
    
    var body: some View {
        VStack {
            List(defaults, selection: $selectedDefaults) { def in
                Text(def.item).tag(def)
                
                if defaults.firstIndex(of: def) == defaults.count - 1 {
                    Button("Save") {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Select defaults")
        .onAppear {
            self.editMode?.wrappedValue = .active
            selectedDefaults = Set()
        }
    }
}

#Preview {
    AddMultipleView(multiple: Multiple(id: UUID(), name: "Test", defaults: [])) { _ in }
}
