//
//  CartView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//
import SwiftUI

struct CartView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @State private var showingCheckout = false
    @State var restaurantId: String
    @State private var showMainView = false
    @State private var showErrorAlert = false
    
    var body: some View {
        ZStack {
            if showingCheckout {
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingCheckout = false
                    }
            }
            VStack {
                List {
                    ForEach(cartViewModel.cartItems) { cartItem in
                        HStack {
                            VStack(alignment:.leading){
                                Text(cartItem.menuItem.name)
                                Text("$\(cartItem.totalPrice, specifier: "%.2f")")
                    
                            }
                        
                            Spacer()
                            Text("Qty:\(cartItem.quantity)")
                      
                            Button(action: {
                                cartViewModel.updateItem(cartItem: cartItem, quantity: cartItem.quantity-1)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(Color("PrimaryColor"))
                            }

                        }
                    }
                }
                HStack {
                    Spacer()
                    Text("Total: $\(cartViewModel.total, specifier: "%.2f")")
                        .font(.headline)
                    Spacer()
                    Button(action: {
                        if cartViewModel.cartItems.isEmpty{
                            showErrorAlert = true
                        }else{
                            showingCheckout.toggle()
                        }
                    }) {
                        Text("Checkout")
                            .font(.headline)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("Cart", displayMode: .inline)
        }
        .sheet(isPresented: $showingCheckout) {
            CheckoutView(cartViewModel: cartViewModel,restaurantId: restaurantId)
                .onDisappear {
                    if cartViewModel.cartItems.isEmpty{
                        showMainView = true
                    }
                }
        }
        
        .alert(isPresented: $showErrorAlert) {
                   Alert(
                       title: Text("Error"),
                       message: Text("Please add items to your cart"),
                       dismissButton: .default(Text("OK"))
                   )
               }
    }
}
