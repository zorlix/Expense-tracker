//
//  DefaultsView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 18.03.2024.
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
        .toolbar {
            NavigationLink("Add Default") {
                AddDefault(viewModel: viewModel)
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
                viewModel.save()
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
