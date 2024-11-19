//
//  RestaurantView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//


import SwiftUI

struct RestaurantView: View {
    @Binding var showSignInView: Bool
    @StateObject private var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var cartViewModel = CartViewModel()
    
    var body: some View{
        
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(restaurantViewModel.restaurants) { restaurant in
                        //let isSaved = savedRestaurants.contains(restaurant.id)
                        NavigationLink(destination: RestaurantMenuView(restaurantId:restaurant.id,cartViewModel: cartViewModel)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(radius: 4)
                                VStack(alignment: .leading, spacing: 10) {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                    Text(restaurant.restaurantName)
                                        .font(.headline)
                                    Text(restaurant.ownerName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(restaurant.ownerEmail)
                                        .font(.subheadline)
                                    Text(restaurant.ownerPhoneNumber)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    /* Button(action: {
                                     if isSaved {
                                     savedRestaurants.remove(restaurant.id)
                                     } else {
                                     savedRestaurants.insert(restaurant.id)
                                     }
                                     }) {
                                     Image(systemName: isSaved ? "heart.fill" : "heart")
                                     .foregroundColor(isSaved ? .red : .gray)
                                     }*/
                                }
                                .padding()
                                
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Explore")
            
        }
    
}


/*
struct MenuListView: View {
    let restaurantId: String
    @StateObject var viewModel = MenuViewModel()
    
    var body: some View {
        List(viewModel.menuItems) { menuItem in
            Text(menuItem.name)
        }
        .navigationBarTitle("Menu")
        .onAppear {
            viewModel.fetchMenuItems(for: restaurantId)
        }
    }
}



import Foundation
import Firebase

struct MenuItem {
    var id: String?
    var name: String
    var price: Double
    
    init(name: String, price: Double) {
        self.name = name
        self.price = price
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let name = dict["name"] as? String,
              let price = dict["price"] as? Double
        else {
            return nil
        }
        self.id = snapshot.key
        self.name = name
        self.price = price
    }
}

class MenuViewModel: ObservableObject {
    @Published var menuItems = [MenuItem]()
    
    private let db = Database.database().reference().child("menu_items")
    
    func fetchMenuItems(for restaurantId: String) {
        db.child(restaurantId).observe(.value) { (snapshot:DataSnapshot) in
            var menuItems = [MenuItem]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let menuItem = MenuItem(snapshot: snapshot) {
                    menuItems.append(menuItem)
                }
            }
            self.menuItems = menuItems
        }
    }
}
*/
