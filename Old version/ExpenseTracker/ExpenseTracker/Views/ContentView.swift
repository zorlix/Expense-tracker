//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Zorlix on 17.03.2024.
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
                AddMultipleView(multiple: multiple) { array in
                    viewModel.saveMultiple(array)
                }
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
                case 5:
                    DiscrepancyView(total: viewModel.total) { expense in
                        viewModel.saveDescipancy(from: expense)
                    }
                case 6:
                    MigrateDefaultsView { newName, newType, oldDefault in
                        viewModel.migrate(old: oldDefault, new: newName, type: newType)
                    }
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
                        Button("Discrepancy", action: viewModel.navig.navDesc)
                        Button("Migration", action: viewModel.navig.navMigr)
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
//            .onChange(of: viewModel.expenses, viewModel.checkForEmpty)
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
