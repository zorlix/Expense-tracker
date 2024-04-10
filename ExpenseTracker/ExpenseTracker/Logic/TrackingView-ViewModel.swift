//
//  TrackingView-ViewModel.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 20.03.2024.
//

import Foundation

@Observable
class TrackingViewModel {
    // TrackingView
    private(set) var expenses: [Expense]
    private(set) var defaults = Defaults()
    private(set) var types = [Tracker]()
    
    // Delete
    func deleteTracker(at offsets: IndexSet) {
        for offset in offsets {
            types.remove(at: offset)
        }
        save()
    }
    
    // Saving and loading data
    let savePath = URL.documentsDirectory.appending(path: "types.json")
    
    init(expenses: [Expense]) {
        self.expenses = expenses
        
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Tracker].self, from: data)
            types = decoded
        } catch {
            types = []
        }
    }
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(types)
            try encoded.write(to: savePath)
        } catch {
            print("Failed to save types: \(error.localizedDescription)")
        }
    }
    
    // App logic
   func calculate(_ what: String) -> Int {
        var number = 0
        for expense in expenses {
            if expense.item == what {
                if expense.type == "Expense" {
                    number -= expense.amount
                } else {
                    number += expense.amount
                }
            }
        }
        return number
    }
    
    func calculateTotal(from array: [DefaultExpense]) -> Int {
        var result = 0
        for item in array {
            result += calculate(item.item)
        }
        
        return result
    }
    
    func calculateOperation(from array: [Combination]) -> Int {
        var result = 0
        for combo in array {
            let temp = calculateTotal(from: combo.trackedDefaults)
            result += temp
        }
        return result
    }
    
    // AddTracker View
    enum Mode {
        case combination, operation
    }
    
    var selectedMode: Mode = .combination
    var name: String = ""
    
    func annul() {
        selectedMode = .operation
        name = ""
        total = false
        
        /// Combination
        currentDefault = nil
        selectedDefaults = []
        
        /// Operation
        description = ""
        currentCombination = nil
        selectedCombinations = []
    }
    
    func addItem() {
        if selectedMode == .combination {
            if name != "" && currentDefault != nil {
                selectedDefaults.append(currentDefault!)
                currentDefault = nil
            }
        } else if selectedMode == .operation {
            if name != "" && currentCombination != nil {
                selectedCombinations.append(currentCombination!)
                currentCombination = nil
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            if selectedMode == .combination {
                selectedDefaults.remove(at: offset)
            } else if selectedMode == .operation {
                selectedCombinations.remove(at: offset)
            }
        }
    }
    
    func saveTracker() {
        if selectedMode == .combination {
            let newCombo = Combination(id: UUID(), name: name, trackedDefaults: selectedDefaults, total: total)
            types.append(.combination(newCombo))
            save()
        } else if selectedMode == .operation {
            let newOp = Operation(id: UUID(), name: name, description: description == "" ? nil : description, trackedCombinations: selectedCombinations)
            types.append(.operation(newOp))
            save()
        }
    }
    
    /// Operation
    var description: String = ""
    var currentCombination: Combination? = nil
    var selectedCombinations: [Combination] = []
    
    /// Combination
    var total: Bool = false
    var currentDefault: DefaultExpense? = nil
    var selectedDefaults: [DefaultExpense] = []
}
