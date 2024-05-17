//
//  Navigation.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 24.03.2024.
//

import Foundation
import SwiftUI

struct NavigationIdentifier: Hashable {
    let id: Int
}

// View identifiers:
/// DefaultsView - 1
/// TrackingView - 2
/// Calculations - 3
/// Multiple - 4
/// Discrepancy - 5
/// Migration - 6

@Observable class Navigation {
    var path = NavigationPath()
    
    /// Calculations
    func navCalc() {
        path.append(NavigationIdentifier(id: 3))
    }
    
    /// Defaults
    func navDefaults() {
        path.append(NavigationIdentifier(id: 1))
    }
    
    /// Tracking
    func navTracking() {
        path.append(NavigationIdentifier(id: 2))
    }
    
    /// Multiples
    func navMultiple() {
        path.append(NavigationIdentifier(id: 4))
    }
    
    /// Discrepancy
    func navDesc() {
        path.append(NavigationIdentifier(id: 5))
    }
    
    func navMigr() {
        path.append(NavigationIdentifier(id: 6))
    }
}
