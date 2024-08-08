//
//  Counting.swift
//  ExpenseTracker
//
//  Created by Zorlix on 17.03.2024.
//

import Foundation

@Observable
class Counting: Hashable {
    var startingDate = Date.now.addingTimeInterval(-(7*86400))
    var endingDate = Date.now
    
    var loaded: [Expense] = []
    
    var balancePrior: Int = 0
    var income: Int = 0
    var outcome: Int = 0
    var balaneDuring: Int = 0
    var balance: Int = 0
    
    var finished = false
    
    func annul() {
        loaded = []
        balancePrior = 0
        income = 0
        outcome = 0
        balaneDuring = 0
        balance = 0
        finished = false
        
    }
    
    static func ==(lhs: Counting, rhs: Counting) -> Bool {
        lhs.loaded == rhs.loaded
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(loaded)
    }
}
