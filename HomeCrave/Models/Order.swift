//
//  Order.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import Foundation

struct Orders: Codable,Identifiable{
    
    let id: String
    let restaurantId: String
    var cartItems: [CartItem]
    var totalPrice: Double
    let date: Date
    var status: String
    var address: String
    var paymentMethod: String
    let payment: Payment // make sure this property is declared
    
    
    init(restaurantId:String,cartItems: [CartItem], totalPrice: Double, status: String, address: String, paymentMethod: String,payment: Payment) {
           self.id = UUID().uuidString
           self.restaurantId = restaurantId
           self.cartItems = cartItems
           self.totalPrice = totalPrice
           self.date = Date()
           self.status = status
           self.address = address
           self.paymentMethod = paymentMethod
           self.payment = payment
       }
    
    
}

extension Orders {
    func toDict() -> [String: Any] {
        return [
            "id": id,
            "restaurantId": restaurantId,
            "cartItems": cartItems.map{ $0.toDict() },
            "totalPrice": totalPrice,
            "date": date.timeIntervalSince1970,
            "status": status,
            "address": address,
            "paymentMethod": paymentMethod,
            "payment":payment.toDict()
        ]
    }
}

