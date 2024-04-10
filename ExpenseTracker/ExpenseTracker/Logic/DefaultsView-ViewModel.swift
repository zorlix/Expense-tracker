//
//  DefaultsView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 20.03.2024.
//

import Foundation

@Observable
class DefaultsViewModel {
    private(set) var defaults = Defaults()
    
    var item = ""
    var type = "Expense"
    
    func save() {
        let newDefault = DefaultExpense(id: UUID(), item: item, type: type)
        defaults.defaults.append(newDefault)
        defaults.save()
    }
    
    func annull() {
        item = ""
        type = "Expense"
    }
}

