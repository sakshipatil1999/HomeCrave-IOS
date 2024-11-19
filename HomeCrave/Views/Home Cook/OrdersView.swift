//
//  OrdersView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 5/3/23.
//

import Foundation
import SwiftUI


struct Order:Identifiable {
    let id: String
    let userId: String
    var cartItems: [CartItem]
    var totalPrice: Double
    let date: Date
    var status: String
    var address: String
    var paymentMethod: String
    var payment: Payment
}
extension Order {
    func toDict() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
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


struct MenuItems {
    let name: String
    let description: String
    let price: Double
}

struct OrdersView: View {
    // Create an instance of OrderViewModel as an observed object to store and manage the list of orders
    @ObservedObject var orderViewModel = OrderViewModel()

    // State variable for refreshing the view
    @State private var refresh = false

    var body: some View {
        ScrollView {
            // Use a LazyVStack to create a scrollable list of orders
            LazyVStack(spacing: 20) {
                ForEach(orderViewModel.order) { order in
                    // Display each order using the OrderItemView and pass in the order and the orderViewModel
                    OrderItemView(order: order, orderViewModel: orderViewModel)
                }
            }
            .padding()
        }
        // Set the navigation title
        .navigationTitle("My Orders")
    }

    }

struct OrderItemView: View {
    // Order object being displayed in this view
    @State var order: Order

    // Observed object that handles updating the order status
    @ObservedObject var orderViewModel: OrderViewModel

    var body: some View {
        ZStack {
            // White rounded rectangle with shadow
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 4)
            
            // Vertical stack containing the order details
            VStack(alignment: .leading, spacing: 10) {
                Text("Order #\(order.id)")
                    .font(.headline)
                    .foregroundColor(Color("PrimaryColor"))
                
                Text("Address: \(order.address)")
                    .font(.subheadline)
                
                Text("Total: $\(order.totalPrice, specifier: "%.2f")")
                    .font(.subheadline)
                
                Text("Status: \(order.status)")
                    .font(.subheadline)
                
                Divider()
                
                // For each item in the order, display a MenuItemView
                ForEach(order.cartItems) { item in
                    MenuItemView(item: item)
                }
                
                // If the order status is "placed", show a button to mark the order as completed
                if order.status == "placed" {
                    Button(action:{
                        orderViewModel.markOrderComplete(order: order)
                        order.status = "completed"
                    }){
                        Text("Complete Order")
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }

}


    struct MenuItemView: View {
        // The cart item that contains the menu item to be displayed.
        let item: CartItem

        var body: some View {
            HStack {
                // The name and description of the menu item are displayed in a vertical stack.
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.menuItem.name )
                        .font(.headline)
                    Text(item.menuItem.description )
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                // The price of the menu item is displayed on the right side of the stack.
                Text("$\(item.menuItem.price , specifier: "%.2f")")
                    .font(.headline)
            }
        }

    }
