//
//  DiscrepancyView.swift
//  ExpenseTracker
//
//  Created by Zorlix on 12.04.2024.
//

import SwiftUI

struct DiscrepancyView: View {
    @Environment(\.dismiss) var dismiss
    
    var total: Int
    @State private var otherPlacesTotal = [Int]()
    @State private var moneyIRL = 0
    @State private var difference = 0
    
    @State private var moneyPlaces = MoneyPlaces()
    @State private var showingAddPlace = false
    
    var differenceColor: Color {
        if moneyIRL > total {
            return .green
        } else if total > moneyIRL {
            return .red
        } else {
            return .yellow
        }
    }
    
    var onSave: (Expense) -> Void
    
    var body: some View {
        Form {
            HStack {
                Text("Money places:").bold()
                ForEach(moneyPlaces.places, id: \.self) {
                    if moneyPlaces.places.firstIndex(of: $0) == moneyPlaces.places.count - 1 {
                        Text($0)
                    } else {
                        Text("\($0),")
                    }
                }
            }
            
            if moneyPlaces.places.isEmpty == false {
                ForEach($otherPlacesTotal.indices, id: \.self) { index in
                    Section(moneyPlaces.places[index]) {
                        TextField("Amount", value: $otherPlacesTotal[index], format: .number)
                    }
                }
                .onChange(of: otherPlacesTotal, calculate)
            }
            
            Section("Difference:") {
                HStack {
                    Text("Total:").bold()
                    Text("\(total),-")
                }
                
                HStack {
                    Text("Money IRL:").bold()
                    Text("\(moneyIRL),-")
                }
                
                HStack {
                    Text("Difference:").bold()
                    Text("\(difference),-")
                }
                .foregroundStyle(differenceColor)
            }
            
            Section {
                Button("Regulate") {
                    if difference > 0 {
                        let newExpense = Expense(id: UUID(), item: "Unknown income", type: "Income", amount: difference, date: .now)
                        onSave(newExpense)
                    } else if difference < 0 {
                        let newExpense = Expense(id: UUID(), item: "Unknown loss", type: "Expense", amount: -(difference), date: .now)
                        onSave(newExpense)
                    }
                    
                    dismiss()
                }
            }
        }
        .navigationTitle("Solve Discrepancies")
        .onAppear(perform: generateTotals)
        .onChange(of: moneyPlaces.places, generateTotals)
        .sheet(isPresented: $showingAddPlace) {
            AddMoneyPlace(moneyPlaces: moneyPlaces)
        }
        .toolbar {
            Button("Add Place") {
                showingAddPlace = true
            }
        }
    }
    
    init(total: Int, onSave: @escaping (Expense) -> Void) {
        self.total = total
        self.onSave = onSave
    }
    
    func generateTotals() {
        otherPlacesTotal = []
        
        for _ in moneyPlaces.places {
            otherPlacesTotal.append(0)
        }
    }
    
    func calculate() {
        moneyIRL = 0
        difference = 0
        
        for amount in otherPlacesTotal {
            moneyIRL += amount
        }
        
        difference = moneyIRL - total
    }
}

struct AddMoneyPlace: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var moneyPlaces: MoneyPlaces
    
    @State private var newPlace = ""
    
    var body: some View {
        Form {
            Section("Money Places") {
                if moneyPlaces.places.isEmpty {
                    Text("None")
                } else {
                    ForEach(moneyPlaces.places, id: \.self) {
                        if moneyPlaces.places.firstIndex(of: $0) == moneyPlaces.places.count - 1 {
                            Text($0)
                        } else {
                            Text("\($0),")
                        }
                    }
                }
            }
            
            Section("New Place") {
                TextField("Add place name", text: $newPlace)
                Button("Save") {
                    moneyPlaces.places.append(newPlace)
                    newPlace = ""
                    moneyPlaces.save()
                }
                .disabled(newPlace.isEmpty)
                
                Button("Dismiss") {
                    dismiss()
                }
            }
        }
        .navigationTitle("Add Money Place")
    }
}

#Preview {
    DiscrepancyView(total: 12) { _ in }
}
