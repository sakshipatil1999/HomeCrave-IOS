//
//  RegisterRestaurantViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 05/05/23.
//

import Foundation
import Firebase

// Define a class for handling restaurant registration
class RegisterRestaurantViewModel: ObservableObject {
    
    // Create a reference to the Firebase Realtime Database
    private let databaseRef = Database.database().reference()
    
    // Define an asynchronous function for registering a new restaurant
    func registerRestaurant(ownerName: String, restaurantName: String, ownerEmail: String, ownerPhoneNumber: String, ownerPassword: String, openTime: Date, closeTime: Date) async throws{
        
        // Call the createUser() method of the shared AuthenticationManager to create a new user with the given email and password
        let authDataResult = try await AuthenticationManager.shared.createUser(email: ownerEmail, password: ownerPassword)
        
        // Retrieve the user ID from the authentication result
        let uid = authDataResult.uid
        
        // Create a reference to the restaurant's data in the database
        let restaurantRef = databaseRef.child("restaurants/\(uid)")
        
        // Define the restaurant's data
        let restaurantData: [String: Any] = [
            "id": authDataResult.uid,
            "ownerName": ownerName,
            "restaurantName": restaurantName,
            "ownerEmail": ownerEmail,
            "ownerPhoneNumber": ownerPhoneNumber,
            "openTime": openTime.timeIntervalSince1970, // Convert the open time to a UNIX timestamp
            "closeTime": closeTime.timeIntervalSince1970, // Convert the close time to a UNIX timestamp
            "state": "", // Add state data for the restaurant
            "zip": "", // Add zip code data for the restaurant
            "address": "", // Add address data for the restaurant
            "city": "" // Add city data for the restaurant
        ]
        
        // Use the setValue() method of the restaurant reference to save the restaurant data in the database
        try await restaurantRef.setValue(restaurantData)
    }
}
