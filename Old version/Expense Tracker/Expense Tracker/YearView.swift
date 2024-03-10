//
//  YearView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 28.02.2024.
//

import SwiftUI

struct YearView: View {
    let year = Int(Calendar.current.component(.year, from: Date()))
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(2021..<year + 1, id: \.self) { year in
                    NavigationLink {
                        MonthView(year: year)
                    } label: {
                        Text(String(year))
                            .padding(50)
                            .background(.orange)
                            .clipShape(.capsule)
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .fontWeight(.black)
                        
                    }
                }
            }
            .navigationTitle("Select Year")
        }
    }
}

#Preview {
    YearView()
}
