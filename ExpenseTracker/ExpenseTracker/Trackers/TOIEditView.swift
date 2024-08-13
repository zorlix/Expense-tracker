//
//  TOIEditView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import SwiftUI

struct TOIEditView: View {
    @Bindable var tracker: TrackerOfItems
    
    @State private var stringToAdd = ""
    @State private var useOldData: Bool
    
    @FocusState private var textFieldFocused: Bool
    
    var body: some View {
        Form {
            Section("Tracker name") {
                TextField("Name", text: $tracker.name)
            }
            
            Section {
                Toggle("Calculate total", isOn: $tracker.total)
                Toggle("Use old data", isOn: $useOldData)
                
                if useOldData {
                    TextField("Old data", value: $tracker.oldAmount, format: .currency(code: "CZK"))
                        .keyboardType(.decimalPad)
                        .focused($textFieldFocused)
                        .onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                }
            }
            .onChange(of: useOldData, resetOldData)
            
            Section("Add tracked item") {
                TextField("Item", text: $stringToAdd)
                Button("Add item") {
                    if stringToAdd.isEmpty == false {
                        if tracker.trackingStrings.contains(stringToAdd) == false {
                            let edited = stringToAdd.trimmingCharacters(in: .whitespacesAndNewlines)
                            tracker.trackingStrings.insert(edited, at: 0)
                        }
                        stringToAdd = ""
                    }
                }
            }
            
            if tracker.trackingStrings.isEmpty == false {
                Section("Tracked items") {
                    ForEach(tracker.trackingStrings, id: \.self) {
                        Text($0)
                    }
                    .onDelete(perform: removeTracker)
                }
            }
        }
        .navigationTitle("Edit Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if textFieldFocused {
                Button("Done") {
                    textFieldFocused = false
                }
            }
        }
    }
    
    func removeTracker(_ indexSet: IndexSet) {
        for index in indexSet {
            tracker.trackingStrings.remove(at: index)
        }
    }
    
    func resetOldData() {
        if useOldData == false {
            tracker.oldAmount = 0
        }
    }
    
    init(tracker: TrackerOfItems) {
        _tracker = Bindable(wrappedValue: tracker)
        
        _useOldData = State(initialValue: tracker.oldAmount == 0 ? false : true)
    }
}

