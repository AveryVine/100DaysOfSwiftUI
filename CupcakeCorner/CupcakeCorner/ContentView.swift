//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Avery Vine on 2020-11-01.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.cupcakes.type) {
                        ForEach(0 ..< Order.Cupcakes.types.count) {
                            Text(Order.Cupcakes.types[$0])
                        }
                    }
                    
                    Stepper(value: $order.cupcakes.quantity, in: 3 ... 20) {
                        Text("Number of cakes: \(order.cupcakes.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.cupcakes.specialRequestEnabled.animation()) {
                        Text("Any special requests")
                    }
                    
                    if order.cupcakes.specialRequestEnabled {
                        Toggle(isOn: $order.cupcakes.extraFrosting) {
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $order.cupcakes.addSprinkles) {
                            Text("Add extra sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
