//
//  AddTracker.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 21.03.2024.
//

import SwiftUI

struct AddTracker: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: TrackingViewModel
    
    var body: some View {
        Form {
            Section("Parameters") {
                TextField("Name", text: $viewModel.name)
                Picker("Type", selection: $viewModel.selectedMode) {
                    Text("Operation").tag(TrackingViewModel.Mode.operation)
                    Text("Combination").tag(TrackingViewModel.Mode.combination)
                }
                .pickerStyle(.segmented)
                
                if viewModel.selectedMode == .operation {
                    TextField("Description", text: $viewModel.description)
                    Picker("Combination", selection: $viewModel.currentCombination) {
                        Text("None").tag(nil as Combination?)
                        ForEach(viewModel.types, id: \.id) { type in
                            switch type {
                            case .combination(let combination):
                                Text(combination.name).tag(Optional(combination))
                            case .operation:
                                EmptyView()
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button { viewModel.addItem() } label: { Image(systemName: "plus") }
                        Spacer()
                    }
                }
                
                if viewModel.selectedMode == .combination {
                    Toggle("Calculate total?", isOn: $viewModel.total)
                    Picker("Default", selection: $viewModel.currentDefault) {
                        Text("None").tag(nil as DefaultExpense?)
                        ForEach(viewModel.defaults.defaults) { item in
                            Text(item.item).tag(Optional(item))
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button { viewModel.addItem() } label: { Image(systemName: "plus") }
                        Spacer()
                    }
                }
            }
                
            if viewModel.selectedMode == .operation && viewModel.selectedCombinations.isEmpty == false {
                Section("Selected") {
                    ForEach(viewModel.selectedCombinations) { combiantion in
                        Text(combiantion.name)
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
            }
                
            if viewModel.selectedMode == .combination && viewModel.selectedDefaults.isEmpty == false {
                Section("Selected") {
                    ForEach(viewModel.selectedDefaults) { def in
                        Text(def.item)
                    }
                    .onDelete(perform: viewModel.removeItem)
                }
            }
            
        }
        .navigationTitle("Add Tracker")
        .onAppear(perform: viewModel.annul)
        .toolbar {
            Button("Save") {
                viewModel.saveTracker()
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddTracker(viewModel: TrackingViewModel(expenses: []))
    }
}
