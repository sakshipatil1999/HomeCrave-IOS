//
//  SignupView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI
import GoogleSignIn

struct SignupView: View {
    
    // State variable to store user email
    @State private var email: String = ""
    
    // State object of the SignUpViewModel class to handle user authentication
    @StateObject private var authViewModel = SignUpViewModel()
    
    // Binding variables to control whether to show the sign-in view and whether the user is a home cook
    @Binding var showSignInView: Bool
    @Binding var isHomeCook: Bool
    
    var body: some View {
        
        // Set the background color for the view
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            // VStack containing the content of the view
            VStack {
                Spacer()
                
                // VStack containing the sign-in title and buttons for social media and email login
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    
                    // Custom view for a social media login button, with Google login as an example
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google"), authViewModel: authViewModel, showSignInView: $showSignInView, isHomeCook: $isHomeCook).padding(.vertical)
                    
                    // Custom view for an email login button
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "mail")), text: Text("Login via Email"), authViewModel: authViewModel, showSignInView: $showSignInView, isHomeCook: $isHomeCook).padding(.vertical).foregroundColor(Color("TitleTextColor"))
                    
                    // Custom view for a "login as home cook" button
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "mail")), text: Text("Login as Home Cook"), authViewModel: authViewModel, showSignInView: $showSignInView, isHomeCook: $isHomeCook).padding(.vertical).foregroundColor(Color("TitleTextColor"))
                    
                    // NavigationLink to the CreateAccountView
                    NavigationLink(
                        destination: CreateAccountView(showSignInView: $showSignInView).navigationBarHidden(false),
                        label: {
                            PrimaryButton(title: "Create an Account").padding()
                        })
                    
                    // NavigationLink to the RegisterHomeCookView
                    NavigationLink(
                        destination: RegisterHomeCookView(showSignInView: $showSignInView, isHomeCook: $isHomeCook).navigationBarHidden(false),
                        label: {
                            PrimaryButton(title: "Register as HomeCook").padding()
                        })
                }
                
                Spacer()
                Divider()
                Spacer()
                
                // Text and links for terms and conditions
                Text("By signing up you agree to our ")
                Text("Terms & Conditions.")
                    .foregroundColor(Color("PrimaryColor"))
                
                Spacer()
                
            }
            .padding()
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(showSignInView: .constant(false),isHomeCook: .constant(false))
    }
}

struct SocalLoginButton: View {
    // Properties
    var image: Image // The image for the button
    var text: Text // The text to display on the button
    var authViewModel: SignUpViewModel // An instance of the sign up view model
    @Binding var showSignInView: Bool // A binding to determine whether to show the sign in view or not
    @Binding var isHomeCook: Bool // A binding to determine whether the user is a home cook or not

    var body: some View {
        Group {
            // If the button is for Google sign in
            if text == Text("Sign in with Google") {
                // Show a button with an action to sign in with Google
                Button(action: {
                    Task {
                        do {
                            try await authViewModel.signInGoogle() // Use the sign up view model to sign in with Google
                            showSignInView = false // Once signed in, set showSignInView to false to dismiss the sign in view
                        } catch {
                            print(error) // If there's an error, print it
                        }
                    }
                }, label: {
                    // Display the button with the given image and text
                    HStack {
                        image
                            .padding(.horizontal)
                        Spacer()
                        text
                            .font(.title2)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(50.0)
                    .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                })
            }
            // If the button is for login via email
            else if text == Text("Login via Email") {
                // Show a NavigationLink to the LoginView
                NavigationLink(
                    destination: LoginView(showSignInView: $showSignInView).navigationBarHidden(false),
                    label: {
                        // Display the button with the given image and text
                        HStack {
                            image
                                .padding(.horizontal)
                            Spacer()
                            text
                                .font(.title2)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    })
            }
            // If the button is for login as a home cook
            else if text == Text("Login as Home Cook") {
                // Show a NavigationLink to the RLoginView
                NavigationLink(
                    destination: RLoginView(showSignInView: $showSignInView,isHomeCook:$isHomeCook).navigationBarHidden(false),
                    label: {
                        // Display the button with the given image and text
                        HStack {
                            image
                                .padding(.horizontal)
                            Spacer()
                            text
                                .font(.title2)
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(50.0)
                        .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                    })
            }
        }
    }
}
