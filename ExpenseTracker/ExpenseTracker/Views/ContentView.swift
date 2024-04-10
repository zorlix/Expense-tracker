//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.navig.path) {
            List {
                ForEach(viewModel.expenses) { expense in
                    NavigationLink(value: expense) {
                        ExpenseItemView(expense: expense)
                    }
                }
                .onDelete(perform: viewModel.deleteWithSwipe)
            }
            .navigationTitle("Expense Tracker")
            .navigationDestination(for: Expense.self) { expense in
                EditView(expense: expense) {
                    viewModel.saveReturned(original: expense, incoming: $0)
                }
            }
            .navigationDestination(for: Multiple.self) { multiple in
                SelectMultiple(multiple: multiple)
            }
            .navigationDestination(for: NavigationIdentifier.self) { identifier in
                switch identifier.id {
                case 1:
                    DefaultsView()
                case 2:
                    TrackingView(expenses: viewModel.expenses)
                case 3:
                    CountingView(expenses: viewModel.expenses, counting: viewModel.calculations)
                case 4:
                    AddMultiplesView(multiples: viewModel.multiples)
                default:
                    EmptyView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Options...") {
                        Button("Remove All", action: viewModel.removeAll)
                        Button("Calculations", action: viewModel.navig.navCalc)
                        Button("Defaults", action: viewModel.navig.navDefaults)
                        Button("Tracker", action: viewModel.navig.navTracking)
                        Button("Load data") { viewModel.importFile = true }
                        Button("Add multiple", action: viewModel.navig.navMultiple) 
                        ShareLink(item: viewModel.savePath)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(viewModel.multiples.items) { thing in
                            NavigationLink(value: thing) {
                                Text(thing.name)
                            }
                        }
                    } label: {
                        Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Expense", systemImage: "plus", action: viewModel.newExpense)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text("\(viewModel.total)")
                            .foregroundStyle(viewModel.total < 0 ? .red : .green)
                    }
                    .bold()
                }
            }
            .onAppear(perform: viewModel.sort)
            .fileImporter(isPresented: $viewModel.importFile, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let fileURL):
                    viewModel.importData(from: fileURL)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
