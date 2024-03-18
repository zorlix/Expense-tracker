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
        NavigationStack(path: $viewModel.path) {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Options...") {
                        #if DEBUG
                        Button("Test", action: viewModel.test)
                        #endif
                        Button("Remove All", action: viewModel.removeAll)
                        NavigationLink("Calculations") {
                            CountingView(expenses: viewModel.expenses, counting: viewModel.calculations)
                        }
                        Button("Load data") { viewModel.importFile = true }
                        ShareLink(item: viewModel.savePath)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Expense", systemImage: "plus", action: viewModel.newExpense)
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
