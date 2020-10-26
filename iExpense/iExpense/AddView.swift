//
//  AddView.swift
//  iExpense
//
//  Created by Avery Vine on 2020-10-25.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var isShowingValidationWarning = false
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add New Expense")
            .navigationBarItems(trailing: Button("Save") {
                guard let actualAmount = Int(amount) else {
                    isShowingValidationWarning.toggle()
                    return
                }
                let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                self.expenses.items.append(item)
                presentationMode.wrappedValue.dismiss()
            })
        }
        .alert(isPresented: $isShowingValidationWarning) {
            Alert(title: Text("That's not a number!"),
                  message: Text("Please enter a number in the \"Amount\" field."),
                  dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
