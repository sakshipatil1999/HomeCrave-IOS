//
//  RHomePageView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import SwiftUI
import FirebaseAuth

struct RHomePageView: View {
    
    
    @Binding var showSignInView: Bool // Binding variable to track if the Sign In view is being shown
    @Binding var isHomeCook: Bool // Binding variable to track if the user is a registered restaurant owner
    @State var restaurantId = Auth.auth().currentUser?.uid // State variable to store the current user's restaurant ID
    
    var body: some View {
        NavigationView{
            VStack{
                // TabView to show different views for the registered restaurant owner
                TabView {
                    // MenuView shows the list of menu items for the restaurant
                    MenuView(restaurantId: restaurantId ?? "")
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Menu")
                        }
                    // OrdersView shows the list of orders received by the restaurant
                    OrdersView()
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Orders")
                        }
                    // RProfileView shows the profile of the restaurant
                    RProfileView()
                        .tabItem {
                            Image(systemName: "person.circle")
                            Text("Profile")
                        }
                }
            }
            // Setting the accent color for the navigation bar items
            .accentColor(Color("PrimaryColor"))
            // Adding a button to the navigation bar to sign out the current user
            .navigationBarItems(trailing:
                                    Button(action: {
                do {
                    try AuthenticationManager.shared.signOut()
                    showSignInView = true
                    isHomeCook = false
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }, label: {
                Image(systemName: "arrow.backward.square")
                
            })
            )
        }
    }
    
}


struct MenuListItemView: View {
    let menuItem: MenuItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(menuItem.name)
            Text("\(menuItem.price) USD")
        }
    }
}

struct RHomePageView_Previews: PreviewProvider {
    static var previews: some View {
        RHomePageView(showSignInView: .constant(false), isHomeCook: .constant(false))
    }
}
