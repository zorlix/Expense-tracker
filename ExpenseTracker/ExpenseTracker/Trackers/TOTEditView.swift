//
//  TOTEditView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 10.08.2024.
//

import SwiftUI

struct TOTEditView: View {
    @Bindable var tracker: TrackerOfTrackers
    let trackers: [Tracker]
    
    var trackersFiltered: [TrackerOfItems] {
        var array = [TrackerOfItems]()
        
        for tracker in trackers {
            if case let .trackerOfItems(toi) = tracker {
                array.append(toi)
            }
        }
        
        return array
    }
    
    @State private var selectedTrackers = Set<TrackerOfItems>()
    
    var body: some View {
        List(selection: $selectedTrackers) {
            Section("Tracker name") {
                TextField("Name", text: $tracker.name)
            }
            
            if trackers.isEmpty == false {
                Section("Select trackers") {
                    ForEach(trackersFiltered) { item in
                        Text(item.name).tag(item)
                    }
                    
                    Button("Add selected") {
                        for selectedTracker in selectedTrackers {
                            tracker.trackers.insert(selectedTracker, at: 0)
                        }
                    }
                }
            }
            
            if tracker.trackers.isEmpty == false {
                Section("Selected trackers") {
                    ForEach(tracker.trackers) { tracker in
                        Text(tracker.name)
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            tracker.trackers.remove(at: index)
                        }
                    })
                }
            }
        }
        .navigationTitle("Edit Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                EditButton()
            }
        }
    }
}
