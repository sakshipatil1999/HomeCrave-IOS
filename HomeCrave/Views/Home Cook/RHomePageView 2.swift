//
//  RHomePageView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 5/2/23.
//

import Foundation
import SwiftUI

struct RHomePageView: View {
    var body: some View {
        TabView {
            MenuView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Menu")
                }
            OrdersView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Orders")
                }
            RNotificationsView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            RProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}






