//
//  Payment.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 06/05/23.
//

import Foundation

struct Payment:Codable,Identifiable {
    let id: String
    let cardNumber: String
    let cardName: String
    let expirationMonth: String
    let expirationYear: String
    let cvv: String
    
    init(id: String, cardNumber: String, cardName: String, expirationMonth: String, expirationYear: String, cvv: String) {
        self.id = id
        self.cardNumber = cardNumber
        self.cardName = cardName
        self.expirationMonth = expirationMonth
        self.expirationYear = expirationYear
        self.cvv = cvv
    }

   
    
    func toDict() -> [String: Any] {
        return [
            "id": id,
            "cardNumber": cardNumber,
            "cardName": cardName,
            "expirationMonth": expirationMonth,
            "expirationYear": expirationYear,
            "cvv": cvv
        ]
    }
}
