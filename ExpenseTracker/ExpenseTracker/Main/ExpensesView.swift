//
//  ExpensesView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 09.08.2024.
//

import SwiftData
import SwiftUI

struct ExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @Query var expenses: [Expense]
    
    var body: some View {
        List {
            ForEach(expenses) { expense in
                NavigationLink(value: expense) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.item)
                                .font(.headline)
                            
                            Text(expense.date, format: .dateTime.day().month().year())
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        Text(expense.amount, format: .currency(code: "CZK"))
                            .foregroundStyle(expense.type == "Expense" ? .red : .green)
                    }
                }
            }
            .onDelete(perform: deleteExpense)
        }
        .navigationDestination(for: Expense.self) { expense in
            ExpenseEditView(expense: expense)
        }
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        for index in indexSet {
            let toDel = expenses[index]
            modelContext.delete(toDel)
        }
    }
    
    init() {
        _expenses = Query(sort: \Expense.date, order: .reverse)
    }
}
