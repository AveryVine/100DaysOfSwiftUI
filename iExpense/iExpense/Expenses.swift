//
//  Expenses.swift
//  iExpense
//
//  Created by Avery Vine on 2020-10-25.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        guard let items = UserDefaults.standard.data(forKey: "Items"),
              let decoded = try? JSONDecoder().decode([ExpenseItem].self, from: items) else {
            self.items = []
            return
        }
        self.items = decoded
    }
}
