//
//  ComparisonView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 11.08.2024.
//

import SwiftData
import SwiftUI

struct ComparisonView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    var total: Int
    
    @AppStorage("moneyIRL") private var moneyIRL: Int = 0
    var difference: Int {
        moneyIRL - total
    }
    
    @State private var addAmount: Int = 0
    @FocusState private var textFieldFocused: Bool
    var formattedNumber: String {
        Formatter.textFieldZeroFormat.string(from: NSNumber(value: addAmount))!
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Add amount", value: $addAmount, formatter: Formatter.textFieldZeroFormat)
                    .keyboardType(.decimalPad)
                    .focused($textFieldFocused)
                    .onAppear {
                        UITextField.appearance().clearButtonMode = .whileEditing
                    }
            }
            
            Section {
                Button("Add amount") {
                    moneyIRL += addAmount
                    addAmount = 0
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            }
            .listRowBackground(Color.blue)
            
            Section {
                Button("Clear true balance") {
                    moneyIRL = 0
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            }
            .listRowBackground(Color.blue)
            
            Section("Data") {
                HStack {
                    Text("Balance in app:")
                        .bold()
                    
                    Text("\(total),-")
                }
                
                HStack {
                    Text("True balanace:")
                        .bold()
                    
                    Text("\(moneyIRL),-")
                }
                
                HStack {
                    Text("Difference:")
                        .bold()
                    
                    Text("\(difference),-")
                }
                .foregroundStyle(difference == 0 ? .yellow : (difference > 0 ? .green : .red))
            }
            
            Section {
                Button("Add discrepancy", action: resolveDisc)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
            }
            .listRowBackground(Color.blue)
        }
        .navigationTitle("Comparison")
    }
    
    func resolveDisc() {
        dismiss()
        
        if difference == 0 {
            return
        } else if difference > 0 {
            let newExpense = Expense(item: "Unknown gain", type: "Income", amount: difference, date: .now)
            modelContext.insert(newExpense)
        } else if difference < 0 {
            let newExpense = Expense(item: "Unknown expense", type: "Expense", amount: abs(difference), date: .now)
            modelContext.insert(newExpense)
        }
    }
}
