//
//  Utilities.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//


import Foundation
import UIKit
final class Utilities {
    
    static let shared = Utilities() // Singleton instance of Utilities
    
    private init() {} // Private initializer to prevent creation of additional instances
    
    @MainActor // Attribute indicating that this method must be executed on the main thread
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        // Retrieve the first connected scene from the UIApplication and cast it as a UIWindowScene
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowScene = scene as? UIWindowScene else {
            fatalError("Unable to retrieve window scene")
        }

        // Get the first window that is currently the key window from the UIWindowScene
        let window = windowScene.windows.first { $0.isKeyWindow }

        // If no controller is provided, use the root view controller of the window
        let controller = controller ?? window?.rootViewController
        
        // If the controller is a UINavigationController, get the top view controller from its stack
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        
        // If the controller is a UITabBarController, get the selected view controller
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        
        // If the controller has a presented view controller, get the top view controller from the presented view controller
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        // Return the controller (which may be the original provided controller or the root view controller)
        return controller
    }
}
