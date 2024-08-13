//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Josef Černý on 08.08.2024.
//

import Foundation
import SwiftData

@Model
class Expense: Codable {
    enum CodingKeys: CodingKey {
        case item, type, amount, date
    }
    
    var item: String
    var type: String
    var amount: Int
    var date: Date
    
    init(item: String, type: String, amount: Int, date: Date) {
        self.item = item
        self.type = type
        self.amount = amount
        self.date = date
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        item = try container.decode(String.self, forKey: .item)
        type = try container.decode(String.self, forKey: .type)
        amount = try container.decode(Int.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(item, forKey: .item)
        try container.encode(type, forKey: .type)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
    }
}

