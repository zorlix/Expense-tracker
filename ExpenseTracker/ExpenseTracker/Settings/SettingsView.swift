//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 09.08.2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Defaults") {
                    DefaultsView()
                }
            }
        }
    }
}

