//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Avery Vine on 2020-10-25.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let amount: Int
    
    init(id: UUID = UUID(), name: String, type: String, amount: Int) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
    }
}
