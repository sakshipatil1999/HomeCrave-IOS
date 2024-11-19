//
//  WelcomeScreenView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI
struct WelcomeScreenView: View {
    var body: some View {
        NavigationView { // Embedding the view in a NavigationView
            ZStack {
                Color("BgColor").edgesIgnoringSafeArea(.all) // Background color with edges ignored
                VStack {
                    Spacer() // Spacer to push the image to the top of the screen
                    Image(uiImage: #imageLiteral(resourceName: "onboard")) // Image to display
                    Spacer() // Spacer to push the button to the bottom of the screen
                    
                    NavigationLink( // Navigation link to navigate to the SignupView
                        destination: SignupView(showSignInView: .constant(true),isHomeCook: .constant(false)).navigationBarHidden(true),
                        label: {
                            PrimaryButton(title: "Get Started").padding() // Button to navigate to the SignupView
                        })
                        .navigationBarHidden(true) // Hide the navigation bar
                    
                }
                .padding() // Add some padding around the VStack
            }
        }
    }
} 

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
