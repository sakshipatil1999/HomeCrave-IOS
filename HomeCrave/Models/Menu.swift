//
//  Menu.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import Foundation

// Define a struct called "Menu"

struct Menu: Identifiable {
    // Define the properties of a menu
    let id: UUID
    let name: String
    let items: [MenuItem]
    
    // Define an initializer for the Menu struct
    init(id: UUID, name: String, items: [MenuItem]) {
        self.id = id
        self.name = name
        self.items = items
    }
}

