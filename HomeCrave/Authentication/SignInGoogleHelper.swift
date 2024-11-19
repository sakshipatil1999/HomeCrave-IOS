//
//  SignInGoogleHelper.swift
//  SwiftfulFirebaseBootcamp
//
//  Created by Nick Sarno on 1/21/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String   // Google ID token
    let accessToken: String   // Google access token
    let name: String?   // User's name obtained from Google
    let email: String?   // User's email obtained from Google
}

final class SignInGoogleHelper {
    
    // This method attempts to sign in the user using Google Sign In.
    // It throws an error if it fails to find the top view controller or if it fails to obtain the ID token from Google.
    // If it succeeds, it returns an instance of GoogleSignInResultModel with the ID token, access token, name, and email.
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let name = gidSignInResult.user.profile?.name
        let email = gidSignInResult.user.profile?.email

        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
        return tokens
    }
    
}

