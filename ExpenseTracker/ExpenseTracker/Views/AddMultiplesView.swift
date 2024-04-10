//
//  AddMultiplesView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.04.2024.
//

import SwiftUI

struct AddMultiplesView: View {
    @State private var viewModel: MultiplesViewModel
    
    var body: some View {
        Form {
            ForEach(viewModel.multiples.items) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        VStack {
                            ForEach(item.defaults) { def in
                                Text(def.item)
                            }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.multiples.delete(item: item)
                    } label: {
                        Image(systemName: "delete.backward.fill")
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .navigationTitle("Multiples")
        .toolbar {
            NavigationLink {
                AddIndividualMultipleView(viewModel: viewModel)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
    
    init(multiples: Multiples) {
        _viewModel = State(initialValue: MultiplesViewModel(multiples: multiples))
    }
}

struct AddIndividualMultipleView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: MultiplesViewModel
    
    
    var body: some View {
        Form {
            Section("Parameters") {
                TextField("Name", text: $viewModel.name)
                Picker("Add default", selection: $viewModel.selectedDefault) {
                    Text("None").tag(nil as DefaultExpense?)
                    ForEach(viewModel.defaults.defaults) { item in
                        Text(item.item).tag(Optional(item))
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: viewModel.addItem) {
                        Image(systemName: "plus")
                    }
                    
                    Spacer()
                }
            }
            
            if viewModel.selectedDefaults.isEmpty == false {
                Section("Selected Defaults") {
                    List {
                        ForEach(viewModel.selectedDefaults) { item in
                            HStack {
                                Text(item.item)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.removeItem(item)
                                } label: {
                                    Image(systemName: "delete.backward.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                }
            }
            
            Section("Save") {
                Button("Save") {
                    viewModel.saveMultiple()
                    dismiss()
                }
            }
        }
        .navigationTitle("Add Multiple")
    }
}

#Preview {
    AddMultiplesView(multiples: Multiples())
}
