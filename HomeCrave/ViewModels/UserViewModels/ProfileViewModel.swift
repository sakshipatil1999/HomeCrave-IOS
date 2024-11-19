//
//  ProfileViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//


import Foundation
import Firebase
import FirebaseStorage
import UIKit

class ProfileViewModel: ObservableObject {
    // The user's profile image
    @Published var profileImage: UIImage?
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var zip: String = ""
    


    // Firebase references
    private let user = Auth.auth().currentUser
    private let storageRef = Storage.storage().reference()
    private let databaseRef = Database.database().reference()
    
    func createProfile(){
        guard let uid = user?.uid else { return }
        // Update user profile details in Firebase Realtime Database
        let profileDetailsRef = databaseRef.child("users/\(uid)/")
        let values: [String: Any] = ["name": name,"email": email,"phoneNumber": phoneNumber,"address":address,"city":city,"state":state,"zip":zip    ]
        profileDetailsRef.updateChildValues(values)
    }

    // Load the user's profile details and profile image from Firebase
    func loadProfile() {
        guard let uid = user?.uid else { return }
        
        // Load profile image from Firebase Storage
        let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
        profileImageRef.downloadURL { url, error in
            if let url = url {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data {
                        DispatchQueue.main.async {
                            self.profileImage = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        // Load user profile details from Firebase Realtime Database
        let profileDetailsRef = databaseRef.child("users/\(uid)/")
        profileDetailsRef.observeSingleEvent(of: .value) { (snapshot:DataSnapshot)  in
            if let profileDetails = snapshot.value as? [String: Any] {
                self.name = profileDetails["name"] as? String ?? ""
                self.email = profileDetails["email"] as? String ?? ""
                self.phoneNumber = profileDetails["phoneNumber"] as? String ?? ""
                self.address = profileDetails["address"] as? String ?? ""
                self.zip = profileDetails["zip"] as? String ?? ""
                self.state = profileDetails["state"] as? String ?? ""
                self.city = profileDetails["city"] as? String ?? ""
            }
        }
    }

    // Update the user's profile details and profile image in Firebase
    func updateProfile() {
        guard let uid = user?.uid else { return }
        
        // Upload profile image to Firebase Storage
        if let profileImage = profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.5) {
            let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
            profileImageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                    
                } else {
                    // Save image URL to Firebase Realtime Database
                    profileImageRef.downloadURL { url, error in
                        if error != nil {
                            print("Error getting profile image URL: (error.localizedDescription)")
                            
                        } else if let url = url {
                            let profileDetailsRef = self.databaseRef.child("users/\(uid)/")
                            let values: [String: Any] = ["profileImageUrl": url.absoluteString]
                            profileDetailsRef.updateChildValues(values)
                        }
                    }
                }
            }
        }
        
        // Update user profile details in Firebase Realtime Database
        let profileDetailsRef = databaseRef.child("users/\(uid)/")
        let values: [String: Any] = ["name": name,"email": email,"phoneNumber": phoneNumber,"address":address,"city":city,"state":state,"zip":zip    ]
        profileDetailsRef.updateChildValues(values)
    }

    // Update only the user's profile image in Firebase
    func updateProfilePic(){
        guard let uid = user?.uid else { return }
        // Upload profile image to Firebase Storage
        if let profileImage = profileImage,
           let imageData = profileImage.jpegData(compressionQuality: 0.5) {
            let profileImageRef = storageRef.child("users/\(uid)/profile.jpg")
            profileImageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading profile image: \(error.localizedDescription)")
                    
                } else {
                    // Save image URL to Firebase Realtime Database
                    profileImageRef.downloadURL { url, error in
                        if error != nil {
                            print("Error getting profile image URL: (error.localizedDescription)")
                            
                        } else if let url = url {
                            let profileDetailsRef = self.databaseRef.child("users/\(uid)/")
                            let values: [String: Any] = ["profileImageUrl": url.absoluteString]
                            profileDetailsRef.updateChildValues(values)
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}



