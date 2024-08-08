//
//  DefaultsView.swift
//  ExpenseTracker
//
//  Created by Zorlix on 18.03.2024.
//
// NavigationIdentifier - 1

import SwiftUI

struct DefaultsView: View {
    @State private var viewModel = DefaultsViewModel()
    
    var body: some View {
        Form {
            Section("List") {
                ForEach(viewModel.defaults.defaults) { item in
                    HStack {
                        Text(item.item)
                            .foregroundStyle(item.type == "Expense" ? .red : .green)
                        
                        Spacer()
                        
                        Button {
                            viewModel.defaults.delete(item: item)
                        } label: {
                            Image(systemName: "delete.left.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Defalts")
        .onAppear(perform: viewModel.sort)
        .onChange(of: viewModel.defaults.defaults, viewModel.sort)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddDefault(viewModel: viewModel)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct AddDefault: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var viewModel: DefaultsViewModel
    
    var body: some View {
        Form {
            TextField("Item", text: $viewModel.item)
            Picker("Type", selection: $viewModel.type) {
                Text("Expense").tag("Expense")
                Text("Income").tag("Income")
            }
            Button("Save") {
                if viewModel.item.isEmpty == false {
                    viewModel.save()
                    viewModel.sort()
                }
                dismiss()
            }
        }
        .navigationTitle("New Default")
        .onAppear(perform: viewModel.annull)
    }
}

#Preview {
    NavigationStack {
        DefaultsView()
    }
}
