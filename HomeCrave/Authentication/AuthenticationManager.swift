//
//  AuthenticationManager.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Nick Sarno on 1/21/23.
//

import Foundation
import FirebaseAuth

// AuthProviderOption enum to represent the available authentication providers
enum AuthProviderOption: String {
    case email = "password"
    case google = "google.com"
    
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    // Get the currently authenticated user or throw an error if there is none
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
        
    // Get a list of authentication providers for the currently authenticated user
    func getProviders() throws -> [AuthProviderOption] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        var providers: [AuthProviderOption] = []
        for provider in providerData {
            if let option = AuthProviderOption(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider option not found: \(provider.providerID)")
            }
        }
        print(providers)
        return providers
    }
        
    // Sign out the current user
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Delete the current user account
    func delete() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        
        try await user.delete()
    }
    
}

// MARK: SIGN IN EMAIL

extension AuthenticationManager {
    
    // Function to create a new user with the given email and password
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Function to sign in a user with the given email and password
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    // Function to reset a user's password with the given email
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // Function to update a user's password with the given password
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        try await user.updatePassword(to: password)
    }

}
// MARK: SIGN IN SSO
// This extension adds authentication methods using Firebase Auth for signing in with Google

extension AuthenticationManager {
    
    // Sign in with Google using the tokens returned by Google Sign In API
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        return try await signIn(credential: credential)
    }

    // Sign in with Firebase Auth using the given credential
    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
}

