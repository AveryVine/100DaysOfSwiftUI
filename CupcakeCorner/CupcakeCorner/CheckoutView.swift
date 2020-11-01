//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Avery Vine on 2020-11-01.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(order.cupcakes.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place Order", action: placeOrder)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text(confirmationTitle), message: Text(confirmationMessage), dismissButton: .default(Text("Dismiss")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                confirmationTitle = "Something went wrong"
                confirmationMessage = "Your order didn't go through. Please try again in a few minutes."
                showingConfirmation = true
                return
            }
            
            print("Order successfully submitted")
            let quantity = decodedOrder.cupcakes.quantity
            let cupcakeType = Order.Cupcakes.types[decodedOrder.cupcakes.type].lowercased()
            confirmationTitle = "Thank You!"
            confirmationMessage = "Your order for \(quantity) \(cupcakeType) cupcakes is on its way!"
            showingConfirmation = true
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
