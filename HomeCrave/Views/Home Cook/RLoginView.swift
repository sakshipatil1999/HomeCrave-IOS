//
//  RLoginView.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import SwiftUI

struct RLoginView: View {
    // The state variables to hold user input for email and password
    @State private var email = ""
    @State private var password = ""

    // The state variables to hold the visual state of the error borders for email and password fields
    @State private var wrongEmail: Float = 0
    @State private var wrongPassword: Float  = 0

    // The state variable to keep track of whether to show the login screen or not
    @State private var showingLoginScreen = false

    // The view model to handle the sign-in functionality
    @StateObject var createAccountViewModel = CreateAccountViewModel()

    // The binding variables to keep track of whether to show the sign-in screen and whether the user is a home cook
    @Binding var showSignInView: Bool
    @Binding var isHomeCook: Bool

    var body: some View {
        // The navigation view to wrap the login screen
        NavigationView {
            // A ZStack to hold the UI elements of the login screen
            ZStack {
                // The main content of the login screen
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 30)
                    
                    // The email text field
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongEmail))
                    
                    // The password secure text field
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    // The login button
                    Button(action: {
                        // Use a Task to perform asynchronous work
                        Task {
                            do {
                                // Call the sign-in method in the view model
                                try await createAccountViewModel.signIn(email: email,password: password)
                                // Update the binding variables to hide the sign-in screen and show the home page view for home cooks
                                showSignInView = false
                                isHomeCook = true
                            } catch {
                                // Print the error if there is any
                                print(error)
                            }
                        }
                    }, label: {
                        Text("Login")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TitleTextColor"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryColor"))
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.all)
                    })
                }
            }.navigationBarHidden(true)
        }
    }
}

    struct RLoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(showSignInView: .constant(false))
        }
    }
    


