//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section("Roky") {
                    NavigationLink("2024") {
                        MothView(year: 2024)
                    }
                }
                
                Section("Přidat") {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("iExpense")
        }
    }
}

#Preview {
    ContentView()
}
