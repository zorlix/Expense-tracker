//
//  MonthView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 28.02.2024.
//

import SwiftUI

struct MonthView: View {
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    let year: Int
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(months, id: \.self) { month in
                    NavigationLink {
                        let thisMonth = months.firstIndex(of: month)
                        DayView(month: (thisMonth ?? 0) + 1, year: year)
                    } label: {
                        Text(month)
                    }
                }
            }
            .navigationTitle("Year \(year, format: .number.grouping(.never))")
        }
    }
}

#Preview {
    MonthView(year: 2023)
}
