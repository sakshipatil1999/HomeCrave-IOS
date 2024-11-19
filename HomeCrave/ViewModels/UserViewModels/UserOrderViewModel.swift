//
//  UserOrderViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 06/05/23.
//

import Foundation

import Foundation
import Firebase
import FirebaseAuth

class UserOrderViewModel: ObservableObject{
    
    @Published var order = [Order]()
    let databaseRef = Database.database().reference()
    
    init(){
        guard let uid = Auth.auth().currentUser?.uid else {
           print("error")
            return }
        databaseRef.child("orders").child(uid).observe(.value){ (snapshot:DataSnapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                return
            }
        
           
            for (key, value) in data {
                guard let orderData = value as? [String: Any],
                                      let cartItemsData = orderData["cartItems"] as? [[String: Any]],
                                      let dateData = orderData["date"] as? Double,
                                      let status = orderData["status"] as? String,
                                      let address = orderData["address"] as? String,
                                      let restaurantId = orderData["restaurantId"] as? String,
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
                
                let date = Date(timeIntervalSince1970: dateData)
                print("data parsed ")
                
                let payment = Payment(id:paymentId,cardNumber: cardNumber,
                                      cardName: cardName,
                                      expirationMonth: expirationMonth,
                                      expirationYear: expirationYear,
                                      cvv: cvv)
             
                let orders = Order(id: key,
                                 userId:restaurantId,
                                  cartItems: cartItems,
                                  totalPrice: orderData["totalPrice"] as? Double ?? 0,
                                  date: date,
                                  status: status,
                                  address: address,
                                   paymentMethod:paymentMethod,payment:payment)
                print(orders.id,orders.totalPrice)
                self.order.append(orders)
            }
           
            // do something with orders array here
        }

    }
    
    func markOrderComplete(order: Order) {
      
        let uid = Auth.auth().currentUser?.uid
        
        guard let uid = uid else {
            print("Error: User not logged in")
            return
        }
        
        let orderRef = databaseRef.child("restaurant_orders").child(uid).child(order.id)
        let updates = ["status": "complete"]
        
        orderRef.updateChildValues(updates) { (error, ref) in
            if let error = error {
                print("Error updating order status: \(error.localizedDescription)")
            } else {
                print("Order status updated to complete")
            }
        }
        
        let userOrderRef = databaseRef.child("orders").child(order.userId).child(order.id)
        userOrderRef.updateChildValues(updates) { (error, ref) in
            if let error = error {
                print("Error updating order status: \(error.localizedDescription)")
            } else {
                print("Order status updated to complete")
            }
        }
    }
    
    
}
