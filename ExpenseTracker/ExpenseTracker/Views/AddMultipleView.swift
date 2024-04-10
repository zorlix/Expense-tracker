//
//  SelectMultiple.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.04.2024.
//

import SwiftUI

struct SelectMultiple: View {
    var multiple: Multiple
    
    @Environment(\.editMode) var editMode
    @State private var defaults: [DefaultExpense]
    @State private var selectedDefaults = Set<DefaultExpense>()
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue.isEditing == true {
                VStack {
                    List(defaults, selection: $selectedDefaults) { item in
                        VStack(alignment: .leading) {
                            Text(item.item)
                            Text(item.type)
                        }
                        .tag(item)
                    }
                }
            } else {
                VStack {
                    List(defaults) { item in
                        VStack(alignment: .leading) {
                            Text(item.item)
                            Text(item.type)
                        }
                        
                        NavigationLink("Add Mutliples") {
                            AddMultipleView()
                        }
                    }
                }
            }
        }
        .navigationTitle("Select desired Multiple")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
    }
    
    init(multiple: Multiple) {
        self.multiple = multiple
        
        _defaults = State(initialValue: multiple.defaults)
    }
}

struct AddMultipleView: View {
    var body: some View {
        Text("hi")
    }
}

#Preview {
    SelectMultiple(multiple: Multiple(id: UUID(), name: "Test", defaults: []))
}
