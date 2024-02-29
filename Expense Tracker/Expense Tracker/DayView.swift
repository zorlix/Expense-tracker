//
//  DayView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 28.02.2024.
//

import SwiftData
import SwiftUI

struct DayView: View {
    @Query var expenses: [Expense]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    Text("Name: \(expense.name)")
                    Text("Date: \(expense.date)")
                    Text("Amount: \(expense.amount)")
                    Text("---")
                }
                
            }
            .navigationTitle("Test")
        }
    }
    
    init(month: Int, year: Int) {
        let calendar = Calendar.current
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        
        let monthStart: Date = {
            if let monthStart = calendar.date(from: dateComponents) {
                return monthStart
            } else {
                fatalError("Something went wrong")
            }
        }()
        
        let monthEnd: Date = {
            if let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) {
                return monthEnd
            } else {
                fatalError("Somethign went wrong")
            }
        }()
        
        _expenses = Query(filter: #Predicate<Expense> { expense in
            expense.date >= monthStart && expense.date <= monthEnd
        }, sort: \Expense.date)
    }
}

#Preview {
    DayView(month: 1, year: 2020)
}
