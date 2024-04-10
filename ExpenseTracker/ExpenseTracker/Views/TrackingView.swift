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
                        
                    case .operation(let operation):
                        Section {
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
                .onDelete(perform: viewModel.deleteTracker)
            }
        }
        .navigationTitle("Tracking")
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

#Preview {
    NavigationStack {
        TrackingView(expenses: [])
    }
}
