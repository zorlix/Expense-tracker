//
//  MultiplesView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Zorlix on 08.04.2024.
//

import Foundation

@Observable
class MultiplesViewModel {
    var multiples: Multiples
    
    // Individual
    var defaults = Defaults()
    
    var name = ""
    var selectedDefault: DefaultExpense?
    var selectedDefaults: [DefaultExpense] = []
    
    // Logic
    func addItem() {
        if let selected = selectedDefault {
            selectedDefaults.append(selected)
        }
        selectedDefault = nil
    }
    
    func removeItem(_ item: DefaultExpense) {
        if let index = selectedDefaults.firstIndex(of: item) {
            selectedDefaults.remove(at: index)
        }
    }
    
    func saveMultiple() {
        let newMultiple = Multiple(id: UUID(), name: name, defaults: selectedDefaults)
        multiples.items.append(newMultiple)
        multiples.save()
    }
    
    // Initializer
    init(multiples: Multiples) {
        self.multiples = multiples
    }
}
