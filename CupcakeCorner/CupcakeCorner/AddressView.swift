//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Avery Vine on 2020-11-01.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.address.name)
                TextField("Street Address", text: $order.address.streetAddress)
                TextField("City", text: $order.address.city)
                TextField("Postal Code", text: $order.address.postalCode)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check Out")
                }
                .disabled(!order.address.isValid)
            }
            .navigationBarTitle("Delivery Details", displayMode: .inline)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
