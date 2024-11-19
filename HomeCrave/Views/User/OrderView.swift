//
//  SavedView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI


struct OrderView: View {
    @ObservedObject var orderViewModel = UserOrderViewModel()
    @State private var refresh = false
    
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(orderViewModel.order) { order in
                        OrdersItemView(order: order,orderViewModel:orderViewModel)
                    }
                }
                .padding()
            }
            .navigationTitle("My Orders")
            
        }
}


struct OrdersItemView: View {
    @State var order: Order
    @ObservedObject var orderViewModel:UserOrderViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 4)
            VStack(alignment: .leading, spacing: 10) {
                Text("Order #\(order.id)")
                    .font(.headline) .foregroundColor(Color("PrimaryColor"))
                Text("Address: \(order.address)")
                    .font(.subheadline)
                Text("Total: $\(order.totalPrice, specifier: "%.2f")")
                    .font(.subheadline)
                Text("Status: \(order.status)")
                    .font(.subheadline)
                Divider()
                ForEach(order.cartItems) { item in
                    MenuItemView(item: item)
                }
        
            }
            .padding()
        }
    }
}
