//
//  CartViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import Foundation
import Firebase
import FirebaseAuth

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem]
    @Published var total: Double
    @Published var totalCount:Int
    let db = Database.database().reference()
    
    init() {
        
        self.cartItems = []
        self.total = 0.0
        self.totalCount = 0
        //loadCartItems()
    }
    func loadCartItems() {
        // Load cart items from UserDefaults
        let cartItems = UserDefaults.standard.array(forKey: "cartItems") as? [Data] ?? []
        
        // Decode the cart items from Data to CartItem objects and store them in self.cartItems
        self.cartItems = cartItems.compactMap { try? JSONDecoder().decode(CartItem.self, from: $0) }
        
        // Calculate total price and total item count
        self.calculateTotal()
        self.getTotalItemCount()
    }

    func saveCartItems() {
        // Encode cart items to Data and save them to UserDefaults
        let cartItemsData = self.cartItems.compactMap { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(cartItemsData, forKey: "cartItems")
    }

    func addItem(menuItem: MenuItem) {
        if let index = cartItems.firstIndex(where: { $0.menuItem.id == menuItem.id }) {
            // Increment the quantity if the menu item is already in the cart
            cartItems[index].quantity += 1
        } else {
            // Add a new cart item with quantity 1 if the menu item is not already in the cart
            let cartItem = CartItem(id: UUID().uuidString, menuItem: menuItem, quantity: 1)
            cartItems.append(cartItem)
        }
        
        // Calculate total price and total item count, and save the cart items to UserDefaults
        getTotalItemCount()
        calculateTotal()
        saveCartItems()
    }

    func removeItem(cartItem: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            // Remove the cart item from the cart
            cartItems.remove(at: index)
            
            // Calculate total price and total item count, and save the cart items to UserDefaults
            getTotalItemCount()
            calculateTotal()
            saveCartItems()
        }
    }

    func updateItem(cartItem: CartItem, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            if(quantity == 0){
                // Remove the cart item from the cart if the quantity is 0
                removeItem(cartItem: cartItem)
            }
            else{
                // Update the quantity of the cart item and calculate total price and total item count
                cartItems[index].quantity = quantity
                calculateTotal()
                getTotalItemCount()
                saveCartItems()
            }
        }
    }

    func giveItemCount(cartItem: CartItem) -> Int{
        if let index = cartItems.firstIndex(where: { $0.id == cartItem.id }) {
            // Return the quantity of the cart item
            return cartItems[index].quantity
        }
        // Return 0 if the cart item is not in the cart
        return 0
    }

    func clearCart() {
        // Remove all cart items from the cart
        cartItems.removeAll()
        
        // Calculate total price and total item count, and save the cart items to UserDefaults
        calculateTotal()
        getTotalItemCount()
        saveCartItems()
    }

    func addOrder(order:Orders) async throws {
        // Get the current user's UID
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // Create a restaurant order object based on the order object passed as a parameter
        let restaurantOrder = Order(id:order.id,userId: uid,cartItems: order.cartItems,totalPrice: order.totalPrice,date: order.date,status: order.status,address: order.address,paymentMethod: order.paymentMethod,payment: order.payment)
        
        // Save the order to the database under the current user

        try await db.child("orders").child(uid).child(order.id).setValue(order.toDict())
        try await db.child("restaurant_orders").child(order.restaurantId).child(order.id).setValue(restaurantOrder.toDict())
    }
    
    private func getTotalItemCount()  {
        totalCount =  cartItems.reduce(0) { $0 + $1.quantity }
    }

    
    private func calculateTotal() {
        total = cartItems.reduce(0.0) { $0 + Double($1.quantity) * $1.menuItem.price }
    }
}
