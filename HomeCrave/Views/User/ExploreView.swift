//
//  ExploreView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import SwiftUI
struct ExploreView: View {
    @Binding var showSignInView: Bool
    @ObservedObject private var restaurantViewModel = RestaurantViewModel()
    @ObservedObject var cartViewModel = CartViewModel()
    
    var body: some View{
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(restaurantViewModel.restaurants) { restaurant in
                    NavigationLink(destination: RestaurantMenuView(restaurantId:restaurant.id,cartViewModel: cartViewModel)) {
                        RestaurantView(restaurant: restaurant,restaurantViewModel: restaurantViewModel)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Explore")
            }
        }


struct RestaurantView: View {
    @State var image: UIImage? = nil
    let restaurant: Restaurant
    let restaurantViewModel: RestaurantViewModel
    
    // Initialize the view with the same view model as in ExploreView
       init(restaurant: Restaurant, restaurantViewModel: RestaurantViewModel) {
           self.restaurant = restaurant
           self.restaurantViewModel = restaurantViewModel
       }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 4)
            VStack(alignment: .leading) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(10)
                } else {
                    Image("biryani")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                Text(restaurant.restaurantName)
                    .font(.headline)
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.leading, 20)
                Text(restaurant.ownerName)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.leading, 20)
                    .padding(.bottom,5)
               
            }
            .onAppear {
                restaurantViewModel.getImageFromStorage(restaurantId: restaurant.id) { image in
                    if let image = image {
                        self.image = image
                    } else {
                        // Handle the error case here
                        print("Error loading image for restaurant: \(restaurant.restaurantName)")
                    }
                }
            }
        }
    }
}


