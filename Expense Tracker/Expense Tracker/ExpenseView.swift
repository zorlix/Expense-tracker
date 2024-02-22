//
//  ExpenseView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import SwiftUI

struct ExpenseView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack {
                            Text(item.item)
                            Text("\(item.date)")
                        }
                        
                        Text("\(item.amount)")
                    }
                }
            }
            .navigationTitle("Leden 2024")
        }
    }
}

#Preview {
    ExpenseView()
}
