//
//  RestaurantMenuView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import SwiftUI
import Firebase

struct RestaurantMenuView: View {
    
    @StateObject private var menuItemListViewModel : MenuItemsListViewModel
    @ObservedObject var cartViewModel : CartViewModel
    @State var restaurantId :String
    
    init(restaurantId: String, cartViewModel: CartViewModel) {
        self.restaurantId = restaurantId
        self._menuItemListViewModel = StateObject(wrappedValue: MenuItemsListViewModel(restaurantId: restaurantId))
        self.cartViewModel = cartViewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            List {
                ForEach(menuItemListViewModel.menuItems) { item in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("$\(item.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            cartViewModel.addItem(menuItem: item)
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("PrimaryColor"))
                                .font(.headline)
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Menu")
            
            NavigationLink(destination: CartView(cartViewModel: self.cartViewModel, restaurantId: restaurantId)) {
                ZStack{
                    Image(systemName: "cart.circle.fill")
                        .resizable()
                        .foregroundColor(Color("PrimaryColor"))
                        .frame(width: 60, height: 60)
                        .padding()
                    
                    
                    if cartViewModel.totalCount > 0 {
                        Text("\(cartViewModel.totalCount)")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(10)
                            .background(Color.black)
                            .clipShape(Circle())
                            .offset(x: -10, y: -20)
                    }
                    
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            
                
            }
        }
    }
}
        
        struct RestaurantMenuView_Previews: PreviewProvider {
            static var previews: some View {
                RestaurantMenuView(restaurantId: "123",cartViewModel: CartViewModel())
            }
        }
