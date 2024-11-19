//
//  RestaurantViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import Foundation
import Firebase
import FirebaseStorage
import UIKit

class RestaurantViewModel:ObservableObject{

    @Published var restaurants = [Restaurant]()
    
    // Reference to the Firebase Realtime Database instance
    private let db = Database.database().reference()
    

    
    // Initializes the view model with a restaurant I
    init() {

        // Fetches the menu items for the given restaurant ID from the database and updates the menu items array
        let restaurantRef = db.child("restaurants")
        restaurantRef.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else { return }
            self.restaurants = value.compactMap { (key, data) in
                guard let restaurantData = try? JSONSerialization.data(withJSONObject: data),
                      let restaurant = try? JSONDecoder().decode(Restaurant.self, from: restaurantData) else { return nil }
                print("data captured")
                return restaurant
            }
        }
    }
    
    func getImageFromStorage(restaurantId: String, completion: @escaping (UIImage?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let restaurantRef = storageRef.child("restaurants/\(restaurantId)/profile.jpg")
        
        // Download the image data from Firebase Storage
        restaurantRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            guard error == nil else {
                print("Error downloading image: \(error!)")
                completion(nil)
                return
            }
            
            // Convert the data into a UIImage
            guard let imageData = data, let image = UIImage(data: imageData) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
    }
    
}

