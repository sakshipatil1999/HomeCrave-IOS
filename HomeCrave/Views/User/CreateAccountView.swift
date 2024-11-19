//
//  CreateAccountView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI

struct CreateAccountView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    
    //@StateObject var authViewModel = SignUpViewModel()
    @StateObject var createAccountViewModel = CreateAccountViewModel()
    
    @Binding var showSignInView : Bool
     
    var body: some View {
    
            NavigationView {
                ZStack {
                    
                    VStack {
                        Text("Input Your Credentials")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 30)
                        
                        TextField("Name", text: $name)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(10)
                        
                        
                        Button(action: {
                            Task {
                                do {
                                    try await createAccountViewModel.signUp(email: email, password: password, name: name, phoneNumber: phoneNumber)
                                        showSignInView = false
                                        return
                                    
                                } catch {
                                        print(error)
                                }
                            }
                        }) {
                            Text("Create an Account")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("TitleTextColor"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("PrimaryColor"))
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                        }
                        .padding(.all)
                        
                        /* NavigationLink(
                         destination: HomePageView().navigationBarHidden(true),
                         label: {
                         Text("Create an Account")
                         .font(.title3)
                         .fontWeight(.bold)
                         .foregroundColor(Color("TitleTextColor"))
                         .padding()
                         .frame(maxWidth: .infinity)
                         .background(Color("PrimaryColor"))
                         .cornerRadius(50.0)
                         .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                         .padding(.all)
                         })*/
                        
                        
                        NavigationLink(
                            destination: LoginView(showSignInView: $showSignInView).navigationBarHidden(true),
                            label: {
                                Text("Login Instead")
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
                }.navigationBarHidden(false)
            }
        
    }
}

    struct CreateAccountView_Previews: PreviewProvider {
        static var previews: some View {
            CreateAccountView(showSignInView: .constant(false))
        }
    }
    

