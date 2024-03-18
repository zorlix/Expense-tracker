//
//  ExpenseItemView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 17.03.2024.
//

import SwiftUI

struct ExpenseItemView: View {
    var expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.item)
                    .font(.headline)
                Text(expense.date, format: .dateTime.day().month().year())
                    .font(.subheadline)
            }
            Spacer()
            Text(expense.amount, format: .currency(code: "CZK"))
                .foregroundStyle(expense.type == "Expense" ? .red : .green)
        }
    }
}

#Preview {
    ExpenseItemView(expense: .example)
}
