//
//  CheckoutView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//
import SwiftUI
import MapKit


struct CheckoutView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @State var restaurantId: String
    @State private var cardNumber = ""
    @State private var cardName = ""
    @State private var expirationMonth = ""
    @State private var expirationYear = ""
    @State private var cvv = ""
    @State private var deliveryAddress = ""
    @State private var deliveryCity = ""
    @State private var deliveryState = ""
    @State private var deliveryZip = ""
    @State private var paymentMethod = "Cash"
    @State private var showingAlert = false
    @State private var showingErrorAlert = false
    @ObservedObject var checkoutViewModel = CheckoutViewModel()
    
    var showCardDetails: Bool {
        return paymentMethod == "Credit Card"
    }
    
    var body: some View {
            VStack {
                CheckoutMapView(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
                    .frame(height: 200)
                    
                HStack{
                    Button(action: {
                        checkoutViewModel.refreshLocation()
                    }) {
                        Image(systemName: "location.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    if let location = checkoutViewModel.areaString {
                        Text("Location: \(location)")
                    } else {
                        Text("Location: Unknown")
                    }
                }
           
            Form {
                Section(header: Text("Payment Method") .foregroundColor(Color("PrimaryColor"))) {
                    Picker(selection: $paymentMethod, label: Text("Payment Method") .foregroundColor(Color("PrimaryColor"))) {
                        Text("Cash").tag("Cash")
                        Text("Credit Card").tag("Credit Card")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if paymentMethod == "Credit Card" {
                    Section(header: Text("Credit Card Details") .foregroundColor(Color("PrimaryColor"))) {
                        TextField("Card Number", text: $cardNumber)
                            .keyboardType(.numberPad)
                        TextField("Name on Card", text: $cardName)
                        HStack {
                            TextField("Expiration Month", text: $expirationMonth)
                                .keyboardType(.numberPad)
                            TextField("Expiration Year", text: $expirationYear)
                                .keyboardType(.numberPad)
                        }
                        TextField("CVV", text: $cvv)
                            .keyboardType(.numberPad)
                    }
                }
                
                Section(header: Text("Delivery Address") .foregroundColor(Color("PrimaryColor"))) {
                    TextField("Address", text: $deliveryAddress)
                    TextField("City", text: $deliveryCity)
                    TextField("State", text: $deliveryState)
                    TextField("ZIP", text: $deliveryZip)
                }
                
                
                Section(header: Text("Order Summary") .foregroundColor(Color("PrimaryColor"))) {
                    ForEach(cartViewModel.cartItems) { cartItem in
                        HStack {
                            Text(cartItem.menuItem.name)
                            Spacer()
                            Text("$\(cartItem.menuItem.price * Double(cartItem.quantity), specifier: "%.2f")")
                        }
                    }
                    HStack {
                        Text("Total")
                            .font(.headline) .foregroundColor(Color("PrimaryColor"))
                        Spacer()
                        Text("$\(cartViewModel.total, specifier: "%.2f")")
                            .font(.headline)
                    }
                }
                
            }
            
            Spacer()
            
            Button(action: placeOrder) {
                Text("Place Order")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color("PrimaryColor"))
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationBarTitle("Checkout")
        .alert(isPresented: $showingErrorAlert) {
                   Alert(
                       title: Text("Error"),
                       message: Text("Please enter your complete details"),
                       dismissButton: .default(Text("OK"))
                   )
               }
        .alert(isPresented: $showingAlert) {
            let orderSummary = cartViewModel.cartItems.map { item in
                "\(item.quantity) x \(item.menuItem.name)"
            }.joined(separator: "\n")
            
            return Alert(
                title: Text("Order Placed"),
                message: Text("Your order has been placed successfully.\n\nOrder Summary:\n\(orderSummary)\n\nDelivery Address:\n\(deliveryAddress)\n\nPayment Method:\n\(paymentMethod)"),
                dismissButton: .default(Text("OK")) {
                    // Clear the cart and go back to the home screen
                    cartViewModel.clearCart()
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                }
            )
        }
     
    }
    
    
    private func placeOrder() {
        guard !deliveryAddress.isEmpty, !deliveryCity.isEmpty, !deliveryState.isEmpty, !deliveryZip.isEmpty else {
            // Show an error if any of the delivery address fields are missing
            showingErrorAlert = true
            return
        }
        
        var order: Orders
        
        if paymentMethod == "Cash" {

            order = Orders(
                restaurantId: restaurantId,
                cartItems: cartViewModel.cartItems,
                totalPrice: cartViewModel.total,
                status: "placed",
                address: deliveryAddress+", "+deliveryCity+", "+deliveryState+", "+deliveryZip,
                paymentMethod: "Cash",
                payment: Payment(
                    id:UUID().uuidString,
                    cardNumber: "",
                    cardName: "",
                    expirationMonth: "",
                    expirationYear: "",
                    cvv: ""
                )
            )
        } else {
            guard !cardNumber.isEmpty, !cardName.isEmpty, !expirationMonth.isEmpty, !expirationYear.isEmpty, !cvv.isEmpty else {
                // Show an error if any of the card details are missing
                showingErrorAlert = true
                return
            }
            
            order = Orders(
                restaurantId: restaurantId,
                cartItems: cartViewModel.cartItems,
                totalPrice: cartViewModel.total,
                status: "placed",
                address: deliveryAddress+", "+deliveryCity+", "+deliveryState+", "+deliveryZip,
                paymentMethod: "Card",
                payment: Payment(
                    id:UUID().uuidString,
                    cardNumber: cardNumber,
                    cardName: cardName,
                    expirationMonth: expirationMonth,
                    expirationYear: expirationYear,
                    cvv: cvv
                )
            )
        }
        
        // Here we assume that the restaurant ID is stored in the cart view model
        Task{
            do {
                try await cartViewModel.addOrder(order: order)
                showingAlert=true
            } catch {
                print("Error adding order: \(error.localizedDescription)")
            }
        }
    }
}
