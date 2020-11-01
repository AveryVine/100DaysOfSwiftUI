//
//  Order.swift
//  CupcakeCorner
//
//  Created by Avery Vine on 2020-11-01.
//

import Foundation

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case cupcakes, address
    }
    
    struct Cupcakes: Codable {
        static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
        
        var type = 0
        var quantity = 3
        
        var specialRequestEnabled = false {
            didSet {
                if !specialRequestEnabled {
                    extraFrosting = false
                    addSprinkles = false
                }
            }
        }
        
        var extraFrosting = false
        var addSprinkles = false
        
        var cost: Double {
            var cost = Double(quantity) * 2
            cost += Double(type) / 2
            if extraFrosting {
                cost += Double(quantity)
            }
            if addSprinkles {
                cost += Double(quantity) / 2
            }
            return cost
        }
    }
    
    struct Address: Codable {
        var name = ""
        var streetAddress = ""
        var city = ""
        var postalCode = ""
        
        var isValid: Bool {
            return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !postalCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
    }
    
    @Published var cupcakes = Cupcakes()
    @Published var address = Address()
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cupcakes = try container.decode(Cupcakes.self, forKey: .cupcakes)
        address = try container.decode(Address.self, forKey: .address)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(cupcakes, forKey: .cupcakes)
        try container.encode(address, forKey: .address)
    }
}
