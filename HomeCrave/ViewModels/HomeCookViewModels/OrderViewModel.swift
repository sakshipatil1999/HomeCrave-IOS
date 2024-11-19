//
//  OrderViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 06/05/23.
//

import Foundation
import Firebase
import FirebaseAuth

class OrderViewModel: ObservableObject{
    
    // An observable array of Order objects
    @Published var order = [Order]()
    
    // Firebase Realtime Database reference
    let databaseRef = Database.database().reference()
    
    // Initializer
    init(){
        
        // Check if user is logged in, get their user id
        guard let uid = Auth.auth().currentUser?.uid else {
            print("error")
            return
        }
        
        // Observe the "restaurant_orders" node in the database for changes
        databaseRef.child("restaurant_orders").child(uid).observe(.value){ (snapshot:DataSnapshot) in
            
            // Get the data from the snapshot as a dictionary
            guard let data = snapshot.value as? [String: Any] else {
                return
            }
        
            // Loop through the dictionary and parse each order
            for (key, value) in data {
                
                // Parse the order data from the dictionary
                guard let orderData = value as? [String: Any],
                      let cartItemsData = orderData["cartItems"] as? [[String: Any]],
                      let dateData = orderData["date"] as? Double,
                      let status = orderData["status"] as? String,
                      let address = orderData["address"] as? String,
                      let userId = orderData["userId"] as? String,
                      let paymentMethod = orderData["paymentMethod"] as? String,
                      let paymentData = orderData["payment"] as? [String:Any],
                      let paymentId = paymentData["id"] as? String,
                      let cardNumber = paymentData["cardNumber"] as? String,
                      let cardName = paymentData["cardName"] as? String,
                      let expirationMonth = paymentData["expirationMonth"] as? String,
                      let expirationYear = paymentData["expirationYear"] as? String,
                      let cvv = paymentData["cvv"] as? String
                      else {
                          continue
                      }

                // Parse the cart items data from the dictionary
                let cartItems = cartItemsData.compactMap { itemData -> CartItem? in
                    do {
                        let itemData = try JSONSerialization.data(withJSONObject: itemData)
                        let decoder = JSONDecoder()
                        let cartItem = try decoder.decode(CartItem.self, from: itemData)
                        return cartItem
                    } catch {
                        print("Error decoding cart item: \(error.localizedDescription)")
                        return nil
                    }
                }
                
                // Parse the date data as a Date object
                let date = Date(timeIntervalSince1970: dateData)
                
                // Parse the payment data as a Payment object
                let payment = Payment(id:paymentId,
                                      cardNumber: cardNumber,
                                      cardName: cardName,
                                      expirationMonth: expirationMonth,
                                      expirationYear: expirationYear,
                                      cvv: cvv)
             
                // Create an Order object from the parsed data
                let orders = Order(id: key,
                                   userId:userId,
                                   cartItems: cartItems,
                                   totalPrice: orderData["totalPrice"] as? Double ?? 0,
                                   date: date,
                                   status: status,
                                   address: address,
                                   paymentMethod:paymentMethod,
                                   payment:payment)
                
                // Add the Order object to the "order" array
                self.order.append(orders)
                
                // Print the order ID and total price for debugging purposes
                print(orders.id,orders.totalPrice)
            }
           
            // do something with orders array here
        }
    }

    func markOrderComplete(order: Order) {

        // Get the current user's ID
        let uid = Auth.auth().currentUser?.uid
        
        // Make sure a user is logged in before proceeding
        guard let uid = uid else {
            print("Error: User not logged in")
            return
        }
        
        // Define a reference to the order in the restaurant_orders node of the database
        let orderRef = databaseRef.child("restaurant_orders").child(uid).child(order.id)
        
        // Define the updates that will be made to the order's data in the database
        let updates = ["status": "complete"]
        
        // Update the order's status in the restaurant_orders node of the database
        orderRef.updateChildValues(updates) { (error, ref) in
            if let error = error {
                print("Error updating order status: \(error.localizedDescription)")
            } else {
                print("Order status updated to complete")
            }
        }
        
        // Define a reference to the order in the orders node of the database
        let userOrderRef = databaseRef.child("orders").child(order.userId).child(order.id)
        
        // Update the order's status in the orders node of the database
        userOrderRef.updateChildValues(updates) { (error, ref) in
            if let error = error {
                print("Error updating order status: \(error.localizedDescription)")
            } else {
                print("Order status updated to complete")
            }
        }
    }

    
    
}
