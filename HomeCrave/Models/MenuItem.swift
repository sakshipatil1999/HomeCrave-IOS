//
//  MenuItem.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import Foundation
import Firebase

struct MenuItem: Codable,Identifiable {
    let id : String
    let name: String
    let description: String
    let price: Double
    
    init(name: String,description: String,price: Double) {
            self.id = UUID().uuidString
            self.name = name
            self.description = description
            self.price = price
        }
}

extension MenuItem {
    func toDict() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "description": description,
            "price": price,
        ]
    }
}
