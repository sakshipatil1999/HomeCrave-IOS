//
//  CartItem.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import Foundation

struct CartItem:Codable,Identifiable{
        let id: String
        let menuItem: MenuItem
        var quantity: Int
        var totalPrice: Double {
            menuItem.price * Double(quantity)
        }
    
}

extension CartItem {
    func toDict() -> [String: Any] {
        return [
            "id": id,
            "menuItem": menuItem.toDict(),
            "quantity": quantity
        ]
    }
}
