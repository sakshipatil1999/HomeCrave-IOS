//
//  HomePageView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import SwiftUI
import CoreLocation
import FirebaseAuth

struct HomePageView: View {
    
    @Binding var showSignInView: Bool
    @State private var currentLocation: CLLocation?
    @State private var locationError: Error?
    @State private var locationString: String = ""
    @State private var distanceString: String = ""
    
    var body: some View {
        NavigationView{
            TabView {
                ExploreView(showSignInView: $showSignInView)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }
                OrderView()
                    .tabItem {
                        Image(systemName: "bookmark")
                        Text("Orders")
                    }
                /*NotificationView()
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Notifications")
                    }*/
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
            }
            .accentColor(Color("PrimaryColor"))
            .navigationBarItems(trailing:
                Button(action: {
                    do {
                        try AuthenticationManager.shared.signOut()
                        showSignInView = true
                    } catch {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                }, label: {
                    Image(systemName: "arrow.backward.square") .foregroundColor(Color("PrimaryColor"))
                        
                })
            )

        }
      
    }
    
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(showSignInView: .constant(false))
    }
}
