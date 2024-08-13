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
    
    @Binding var changeTotal: Bool
    
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
            .onAppear(perform: purgeEmpty)
            .onChange(of: expenses) {
                changeTotal = true
            }
        }
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        for index in indexSet {
            let toDel = expenses[index]
            modelContext.delete(toDel)
        }
    }
    
    func purgeEmpty() {
        let fetchDescriptor = FetchDescriptor<Expense>(predicate: #Predicate { expense in
            expense.item == ""
        })
        guard let expenses = try? modelContext.fetch(fetchDescriptor) else { return }
        
        for expense in expenses {
            modelContext.delete(expense)
        }
    }
    
    init(changeTotal: Binding<Bool>, searchString: String, sortOrder: [SortDescriptor<Expense>], limitDate: Bool, startingDate: Date, endingDate: Date) {
        self._changeTotal = changeTotal
        _expenses = Query(filter: #Predicate { expense in
            if limitDate == true {
                if expense.date > startingDate && expense.date < endingDate {
                    if searchString.isEmpty {
                        true
                    } else {
                        expense.item.localizedStandardContains(searchString)
                    }
                } else {
                    false
                }
            } else {
                if searchString.isEmpty {
                    true
                } else {
                    expense.item.localizedStandardContains(searchString)
                }
            }
        }, sort: sortOrder)
    }
}
