//
//  TrackingView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 20.03.2024.
//

import SwiftUI

struct TrackingView: View {
    @State private var viewModel: TrackingViewModel
    
    var body: some View {
        Form {
            List {
                ForEach(viewModel.types, id: \.id) { type in
                    switch type {
                    case .combination(let combination):
                        Section {
                             NavigationLink(value: combination) {
                                VStack(alignment: .leading) {
                                    Text(combination.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    ForEach(combination.trackedDefaults) { def in
                                        let thisRoundValue = viewModel.calculate(def.item)
                                        HStack {
                                            Text(def.item)
                                                .font(.subheadline)
                                                .foregroundStyle(def.type == "Expense" ? .red : .green)
                                            Spacer()
                                            Text(String(thisRoundValue < 0 ? thisRoundValue * -1 : thisRoundValue))
                                        }
                                    }
                                    
                                    if combination.total {
                                        let result = viewModel.calculateTotal(from: combination.trackedDefaults)
                                        HStack {
                                            Text("Total:")
                                            Spacer()
                                            Text(String(result))
                                                .foregroundStyle(result < 0 ? .red : .green)
                                        }
                                        .fontWeight(.semibold)
                                    }
                                }
                            }
                        }
                        
                    case .operation(let operation):
                        Section {
                            NavigationLink(value: operation) {
                                VStack(alignment: .leading) {
                                    Text(operation.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    if operation.description != nil {
                                        HStack {
                                            Text("Description:")
                                                .bold()
                                            Text(operation.description!)
                                        }
                                        .font(.subheadline)
                                    }
                                    
                                    ForEach(operation.trackedCombinations) { combo in
                                        let thisRoundValue = viewModel.calculateTotal(from: combo.trackedDefaults)
                                        HStack {
                                            Text(combo.name)
                                            Spacer()
                                            Text(String(thisRoundValue))
                                                .foregroundStyle(thisRoundValue < 0 ? .red : .green)
                                        }
                                    }
                                    
                                    let result = viewModel.calculateOperation(from: operation.trackedCombinations)
                                    HStack {
                                        Text("Total:")
                                        Spacer()
                                        Text(String(result))
                                            .foregroundStyle(result < 0 ? .red : .green)
                                    }
                                    .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteTracker)
            }
        }
        .navigationTitle("Tracking")
        .navigationDestination(for: Combination.self) { combination in
            CombinationTrackerView(expenses: viewModel.expenses, combination: combination)
        }
        .navigationDestination(for: Operation.self) { operation in
            OperationTrakerView(expenses: viewModel.expenses, operation: operation)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Add Tracker") {
                    AddTracker(viewModel: viewModel)
                }
            }
        }
    }
    
    init(expenses: [Expense]) {
        _viewModel = State(initialValue: TrackingViewModel(expenses: expenses))
    }
}

struct CombinationTrackerView: View {
    var expenses: [Expense]
    var combination: Combination
    
    var defaults: [String] {
        var array = [String()]
        
        for def in combination.trackedDefaults {
            array.append(def.item)
        }
        
        return array
    }
    
    var total: Int {
        var result = 0
        
        if defaults.isEmpty == false {
            for expense in expenses {
                if defaults.contains(expense.item) {
                    if expense.type == "Expense" {
                        result -= expense.amount
                    } else {
                        result += expense.amount
                    }
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                if defaults.contains(expense.item) {
                    ExpenseItemView(expense: expense)
                }
            }
        }
        .navigationTitle(combination.name)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("Total:").bold()
                    Spacer()
                    Text(String(total))
                        .foregroundStyle(total < 0 ? .red : .green)
                }
            }
        }
    }
}

struct OperationTrakerView: View {
    var expenses: [Expense]
    var operation: Operation
    
    var defaults: [String] {
        var result = [String]()
        
        for combination in operation.trackedCombinations {
            for def in combination.trackedDefaults {
                result.append(def.item)
            }
        }
        
        return result
    }
    
    var total: Int {
        var result = 0
        
        if defaults.isEmpty == false {
            for expense in expenses {
                if defaults.contains(expense.item) {
                    if expense.type == "Expense" {
                        result -= expense.amount
                    } else {
                        result += expense.amount
                    }
                }
            }
        }
        
        return result
    }
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                if defaults.contains(expense.item) {
                    ExpenseItemView(expense: expense)
                }
            }
        }
        .navigationTitle(operation.name)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Text("Total:").bold()
                    Spacer()
                    Text(String(total))
                        .foregroundStyle(total < 0 ? .red : .green)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TrackingView(expenses: [])
    }
}
