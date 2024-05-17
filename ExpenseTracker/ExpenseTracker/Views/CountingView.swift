//
//  CountingView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import SwiftUI

struct CountingView: View {
    @State private var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section("Parameters") {
                DatePicker("Starting Date", selection: $viewModel.counting.startingDate, in: ...viewModel.counting.endingDate)
                DatePicker("Ending Date", selection: $viewModel.counting.endingDate, in: viewModel.counting.startingDate...)
            }
            
            Section {
                Button("Calculate", action: viewModel.calculate)
            }
            
            Section("Calculations") {
                Text("Balance prior to selection: \(viewModel.counting.balancePrior)")
                Text("Income during selection: \(viewModel.counting.income)")
                Text("Expenses during selection: \(viewModel.counting.outcome)")
                Text("Balance during selection: \(viewModel.counting.balaneDuring)")
                Text("Balance: \(viewModel.counting.balance)")
            }
            
            if viewModel.counting.finished {
                Section("Expenses") {
                    List {
                        ForEach(viewModel.counting.loaded) { expense in
                            ExpenseItemView(expense: expense)
                        }
                    }
                }
            }
        }
        .navigationTitle("Calculations")
    }
    
    init(expenses: [Expense], counting: Counting) {
        _viewModel = State(initialValue: ViewModel(expenses: expenses, counting: counting))
    }
}

#Preview {
    CountingView(expenses: [], counting: Counting())
}
