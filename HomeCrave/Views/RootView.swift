//
//  RootView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//

import Foundation

import SwiftUI

struct RootView: View {
    // States for controlling whether to show sign in view or not, and whether the user is a home cook or not
    @State private var showSignInView: Bool = false
    @State private var isHomeCook: Bool = false

    var body: some View {
        ZStack {
            // If sign in view is not shown, show the appropriate home page view based on user type
            if !showSignInView {
                if !isHomeCook{
                    HomePageView(showSignInView: $showSignInView)}
                else{
                    RHomePageView( showSignInView: $showSignInView, isHomeCook: $isHomeCook)
                }
            }
        }
        // Check if user is authenticated on app launch and show sign in view if not
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        // Show the sign in view as full screen cover if the state is true
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                SignupView(showSignInView: $showSignInView,isHomeCook: $isHomeCook)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

