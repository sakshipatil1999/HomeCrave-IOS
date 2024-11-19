//
//  Location.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//

import Foundation

class Location: Codable {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
