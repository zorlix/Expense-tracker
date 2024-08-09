//
//  DefaultsView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 09.08.2024.
//

import SwiftUI

struct DefaultsView: View {
    @State private var defaults = Defaults()
    
    var body: some View {
        List {
            Section {
                NavigationLink("Add Default") {
                    AddDefaultView(defaults: defaults)
                }
            }
            
            Section {
                ForEach(defaults.items) { item in
                    HStack {
                        Text(item.name)
                        Text("(\(item.type))")
                            .foregroundStyle(.red)
                    }
                }
                .onDelete(perform: deleteDefault)
            }
        }
        .navigationTitle("Edit Defaults")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func deleteDefault(_ indexSet: IndexSet) {
        for index in indexSet {
            defaults.items.remove(at: index)
        }
    }
}
