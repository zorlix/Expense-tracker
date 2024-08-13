//
//  TrackingView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import SwiftData
import SwiftUI

struct TrackingView: View {
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()
    @State private var tracking = Tracking()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    Button("Add tracker of items") {
                        let newTracker = TrackerOfItems(id: UUID(), name: "", trackingStrings: [], total: false)
                        tracking.items.insert(.trackerOfItems(newTracker), at: 0)
                        tracking.save()
                        path.append(newTracker)
                    }
                    
                    Button("Add tracker of trackers") {
                        let newTracker = TrackerOfTrackers(name: "", trackers: [])
                        tracking.items.insert(.trackerOfTrackers(newTracker), at: 0)
                        tracking.save()
                        path.append(newTracker)
                    }
                }
                
                if tracking.items.isEmpty == false {
                    Section {
                        ForEach(tracking.items, id: \.id) { tracker in
                            switch tracker {
                            case .trackerOfItems(let toi):
                                NavigationLink(value: toi) {
                                    VStack(alignment: .leading) {
                                        Text(toi.name)
                                            .font(.headline)
                                        
                                        if toi.oldAmount != 0 {
                                            HStack {
                                                Text("Old data")
                                                Spacer()
                                                Text(String(toi.oldAmount))
                                                    .foregroundStyle(toi.oldAmount > 0 ? .green : .red)
                                            }
                                            .font(.caption)
                                        }
                                        
                                        ForEach(toi.trackingStrings, id: \.self) { string in
                                            HStack {
                                                Text(string)
                                                Spacer()
                                                Text(String(calculateExpenses(from: string)))
                                                    .foregroundStyle(calculateExpenses(from: string) > 0 ? .green : .red)
                                            }
                                            .font(.caption)
                                        }
                                        
                                        if toi.total {
                                            HStack {
                                                Text("Total")
                                                Spacer()
                                                Text(String(calculateTotal(from: toi.trackingStrings, plus: toi.oldAmount)))
                                                    .foregroundStyle(calculateTotal(from: toi.trackingStrings, plus: toi.oldAmount) > 0 ? .green : .red)
                                            }
                                            .font(.caption.bold())
                                        }
                                    }
                                }
                                
                            case .trackerOfTrackers(let tot):
                                NavigationLink(value: tot) {
                                    VStack(alignment: .leading) {
                                        Text(tot.name)
                                            .font(.headline)
                                        
                                        ForEach(tot.trackers) { tracker in
                                            HStack {
                                                Text(tracker.name)
                                                Spacer()
                                                Text(String(calculateTotal(from: tracker.trackingStrings, plus: tracker.oldAmount)))
                                                    .foregroundStyle(calculateTotal(from: tracker.trackingStrings, plus: tracker.oldAmount) > 0 ? .green : .red)
                                            }
                                            .font(.caption)
                                        }
                                        
                                        HStack {
                                            Text("Total")
                                            Spacer()
                                            Text(String(calculateTotalOfTotals(from: tot.trackers)))
                                                .foregroundStyle(calculateTotalOfTotals(from: tot.trackers) > 0 ? .green : .red)
                                        }
                                        .font(.caption.bold())
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteTracker)
                        .onMove(perform: moveTracker)
                    }
                }
            }
            .navigationTitle("Tracking")
            .navigationDestination(for: TrackerOfItems.self) { tracker in
                TOIEditView(tracker: tracker)
            }
            .navigationDestination(for: TrackerOfTrackers.self) { tracker in
                TOTEditView(tracker: tracker, trackers: tracking.items)
            }
            .onAppear(perform: tracking.trimUnneeded)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    func deleteTracker(_ indexSet: IndexSet) {
        for index in indexSet {
            tracking.items.remove(at: index)
        }
    }
    
    func moveTracker(from source: IndexSet, to destination: Int) {
        tracking.items.move(fromOffsets: source, toOffset: destination)
        tracking.save()
    }
    
    func calculateExpenses(from string: String) -> Int {
        var fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.item.localizedStandardContains(string)
        })
        fetchDescriptor.propertiesToFetch = [\.date]
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return 0 }
        
        var income = 0
        var outcome = 0
        
        for expense in expenses {
            if expense.type == "Expense" {
                outcome += expense.amount
            } else {
                income += expense.amount
            }
        }
        
        return income - outcome
    }
    
    func calculateTotal(from array: [String], plus oldAmount: Int) -> Int {
        var total = 0
        
        for item in array {
            total += calculateExpenses(from: item)
        }
        
        total += oldAmount
        
        return total
    }
    
    func calculateTotalOfTotals(from array: [TrackerOfItems]) -> Int {
        var total = 0
        
        for item in array {
            total += calculateTotal(from: item.trackingStrings, plus: item.oldAmount)
        }
        
        return total
    }
}
