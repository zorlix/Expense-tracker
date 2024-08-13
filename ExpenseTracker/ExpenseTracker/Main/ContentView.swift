//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var path = NavigationPath()
    
    @State private var searchString = ""
    @State private var sortOrder = [SortDescriptor(\Expense.date, order: .reverse)]
    
    @State private var total: Int = 0
    @State private var changeTotal = false

    @State private var showingCalculations = false
    @AppStorage("limitDate") private var limitDate = false
    @AppStorage("startingDate") var startingDate: Date = .now.addingTimeInterval(-(7*86400))
    @AppStorage("endingDate") var endingDate: Date = .now
    
    @State private var showingTrackers = false
    @State private var showingExport = false
    @State private var showingPurge = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ExpensesView(changeTotal: $changeTotal, searchString: searchString, sortOrder: sortOrder, limitDate: limitDate, startingDate: startingDate, endingDate: endingDate)
                .navigationTitle("Expense Tracker")
                .navigationDestination(for: Expense.self) { expense in
                    ExpenseEditView(expense: expense)
                }
                .sheet(isPresented: $showingCalculations) {
                    DateSelectionView(limitDate: $limitDate, startingDate: $startingDate, endingDate: $endingDate)
                        .presentationDetents([.medium, .large])
                }
                .sheet(isPresented: $showingTrackers) {
                    TrackingView()
                }
                .sheet(isPresented: $showingExport) {
                    ExportView()
                        .presentationDetents([.medium, .large])
                }
                .sheet(isPresented: $showingPurge) {
                    PurgeView()
                        .presentationDetents([.medium])
                }
                .searchable(text: $searchString)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add expense", systemImage: "plus", action: addExpense)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu("Options", systemImage: "ellipsis.circle") {
                            NavigationLink {
                                ComparisonView(total: total)
                            } label: {
                                Text("Comparison")
                                Image(systemName: "arrow.down.left.arrow.up.right")
                            }
                            
                            Button("Export and import", systemImage: "square.and.arrow.up.on.square") {
                                showingExport = true
                            }
                            
                            Button("Purge database", systemImage: "arrow.up.trash.fill") {
                                showingPurge = true
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        HStack {
                            Text("Total:")
                                .bold()
                            
                            Text(total, format: .currency(code: "CZK"))
                                .foregroundStyle(total > 0 ? .green : .red)
                        }
                        .onAppear(perform: setTotal)
                        .onChange(of: changeTotal, setTotal)
                        
                        Spacer()
                        
                        Button("Tracking", systemImage: "chart.line.uptrend.xyaxis") {
                            showingTrackers = true
                        }
                        
                        Button("Date restrictions", systemImage: "calendar.badge.clock") {
                            showingCalculations = true
                        }
                    }
                }
        }
    }
    
    func addExpense() {
        let newExpense = Expense(item: "", type: "Expense", amount: 0, date: .now)
        modelContext.insert(newExpense)
        path.append(newExpense)
    }
    
    func setTotal() {
        var fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.date <= endingDate
        })
        fetchDescriptor.propertiesToFetch = [\.date]
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return }
        
        var outcome = 0
        var income = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        total = income - outcome
        changeTotal = false
    }
}

