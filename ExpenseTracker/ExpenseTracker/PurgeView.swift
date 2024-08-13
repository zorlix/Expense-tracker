//
//  PurgeView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 12.08.2024.
//

import SwiftData
import SwiftUI

struct PurgeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var showingConfirmation = false
    
    var count: Int {
        let descriptor = FetchDescriptor<Expense>()
        let result = (try? modelContext.fetchCount(descriptor)) ?? 0
        return result
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Number of objects in database:")
                        Text(String(count))
                            .bold()
                    }
                }
                
                Section {
                    Button("Purge Database") {
                        showingConfirmation = true
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                }
                .listRowBackground(Color.red)
            }
            .navigationTitle("Purge Database")
            .confirmationDialog("Are you sure?", isPresented: $showingConfirmation) {
                Button("Purge", role: .destructive) { 
                    do {
                        try modelContext.delete(model: Expense.self)
                    } catch {
                        print("Failed to delete data: \(error.localizedDescription)")
                    }
                    
                    dismiss()
                }
                
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            } message: {
                Text("This action cannot be undone")
            }
        }
    }
}
