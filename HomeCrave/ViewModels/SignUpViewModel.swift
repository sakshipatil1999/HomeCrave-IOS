//
//  AuthViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

// Import necessary modules
import Foundation
import Firebase

// Define a class for handling user sign-up
final class SignUpViewModel: ObservableObject {
    
    // Create a reference to the Firebase Realtime Database
    private let databaseRef = Database.database().reference()
    
    // Define an asynchronous function for signing in with Google
    func signInGoogle() async throws {
        
        // Instantiate a helper object for signing in with Google
        let helper = SignInGoogleHelper()
        
        // Call the signIn() method of the helper object to retrieve access tokens
        let tokens = try await helper.signIn()
        
        // Call the signInWithGoogle() method of the shared AuthenticationManager to authenticate the user
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        
        // Retrieve the user ID from the authentication result
        let uid = authDataResult.uid
        
        // Update user details in Firebase Realtime Database
        let userDetailsRef = databaseRef.child("users/\(uid)/")
        
        // Define the values to be updated for the user
        let values: [String: Any] = ["email": authDataResult.email ?? ""]
        
        // Use the setValue() method of the user details reference to update the user details in the database
        try await userDetailsRef.setValue(values)
        
    }

}

