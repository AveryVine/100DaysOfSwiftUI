//
//  ContentView.swift
//  iExpense
//
//  Created by Avery Vine on 2020-10-25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var isShowingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .foregroundColor(textColor(for: item.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("iExpense")
            .navigationBarItems(
                leading:
                    EditButton(),
                trailing:
                    Button(action: {
                        isShowingAddExpense.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
            )
        }
        .sheet(isPresented: $isShowingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func textColor(for itemAmount: Int) -> Color {
        if itemAmount > 100 {
            return .red
        } else if itemAmount > 10 {
            return .orange
        }
        return .black
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
