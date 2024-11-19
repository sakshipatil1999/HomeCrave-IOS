//
//  HomeCraveApp.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 01/05/23.
//

import SwiftUI
import FirebaseCore
import CoreLocation

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    CLLocationManager().requestWhenInUseAuthorization()
    return true
  }
    
    
}

@main
struct HomeCraveApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
