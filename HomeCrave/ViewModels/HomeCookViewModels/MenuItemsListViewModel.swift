//
//  MenuItemsListViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import Foundation
import Firebase
import FirebaseAuth

class MenuItemsListViewModel: ObservableObject {
    
    // Published property to observe changes to the menu items array
    @Published var menuItems = [MenuItem]()
    
    // Reference to the Firebase Realtime Database instance
    private let db = Database.database().reference().child("menu_items")
    
    // Restaurant ID for which the menu items are being fetched
    private let restaurantId: String
    
    // Initializes the view model with a restaurant I
    init(restaurantId: String) {
        self.restaurantId = restaurantId
                                          
        // Fetches the menu items for the given restaurant ID from the database and updates the menu items array
        let restaurantMenuItemsRef = db.child(restaurantId)
        restaurantMenuItemsRef.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            self.menuItems = value.compactMap { (key, data) in
                guard let menuItemData = try? JSONSerialization.data(withJSONObject: data),
                      let menuItem = try? JSONDecoder().decode(MenuItem.self, from: menuItemData) else { return nil }
                return menuItem
            }
        }
    }
    
    // Adds a new menu item to the database for the given restaurant ID
    func addMenuItem(name: String, price: Double, description: String) async throws {
    let menuItem = MenuItem(name: name, description: description, price: price)
    let menuItemData = try JSONEncoder().encode(menuItem)
    let menuItemJSON = try JSONSerialization.jsonObject(with: menuItemData) as? [String: Any]
    try await db.child(restaurantId).child(menuItem.id).setValue(menuItemJSON)
    }
}
