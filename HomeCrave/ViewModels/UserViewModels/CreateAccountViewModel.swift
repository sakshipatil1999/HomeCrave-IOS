//
//  CreateAccountViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//

import Foundation
import Firebase

@MainActor
final class CreateAccountViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var error: Error?
    
    private let databaseRef = Database.database().reference()
    
    
    func signUp(email: String, password: String, name: String, phoneNumber: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyCredentials
        }
        
        do {
            let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
            let uid = authDataResult.uid
            
            // Update user user details in Firebase Realtime Database
            let userDetailsRef = databaseRef.child("users/\(uid)/")
            let values: [String: Any] = ["name": name, "email": email, "phoneNumber": phoneNumber]
            try await userDetailsRef.setValue(values)
            
        } catch {
            throw error
        }
    }
    
    
    func signIn(email: String, password: String) async throws {
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyCredentials
        }
        
        do {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        } catch {
            throw AuthError.signInFailed(error.localizedDescription)
        }
    }
    
    enum AuthError: Error {
        case emptyCredentials
        case signInFailed(String)
        case other(Error)
        
        var message: String {
                switch self {
                case .emptyCredentials:
                    return "Please enter your email and password."
                case .signInFailed:
                    return "Please enter a valid email address."
                case .other(let error):
                    return error.localizedDescription
                }
            }
        
    }
    
}
