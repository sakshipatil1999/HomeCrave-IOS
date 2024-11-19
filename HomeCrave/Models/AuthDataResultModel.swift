//
//  AuthDataResultModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//

import Foundation
import FirebaseAuth

// AuthDataResultModel struct to represent the authenticated user's data
struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    // Initialize the struct with a User object from Firebase Auth
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}
