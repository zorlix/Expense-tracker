//
//  Formatter.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 12.08.2024.
//

import Foundation

extension Formatter {
    static let textFieldZeroFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.zeroSymbol = ""
        return formatter
    }()
}
