//
//  MothView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import SwiftUI

struct MothView: View {
    var year: Int
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink("Leden") {
                        ExpenseView()
                    }
                }
            }
        }
    }
}

#Preview {
    MothView(year: 2024)
}
