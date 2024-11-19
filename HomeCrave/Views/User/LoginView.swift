//
//  LoginView.swift
//  HomeCrave
//
//  Created by Tejaswini Shinde on 4/30/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var wrongEmail: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var showingLoginScreen = false
    @StateObject var createAccountViewModel = CreateAccountViewModel()
    @Binding var showSignInView: Bool
    @State private var errorMessage = ""
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 30)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongEmail))
                    
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await createAccountViewModel.signIn(email: email,password: password)
                                    showSignInView = false
                            }
                            catch {
                                errorMessage = error._domain
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

    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView(showSignInView: .constant(false))
        }
    }
    

