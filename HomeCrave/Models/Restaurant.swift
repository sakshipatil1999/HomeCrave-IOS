//
//  Restaurant.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import Foundation
import Firebase

struct Restaurant :Codable,Identifiable{
    
    let id: String
    let restaurantName: String
    let ownerName: String
    let ownerPhoneNumber: String
    let openTime: Date
    let closeTime: Date
    let ownerEmail: String
    let city: String
    let address: String
    let state: String
    let zip: String
    
    
 
    var isOpen: Bool {
        let now = Date()
        return now >= openTime && now <= closeTime
    }
    
    var formattedOpenTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: openTime)
    }
    
    var formattedCloseTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: closeTime)
    }
    
}
