//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Josef Černý on 22.02.2024.
//

import SwiftData
import SwiftUI

@main
struct Expense_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
