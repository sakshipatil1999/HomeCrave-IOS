//
//  CheckoutViewModel.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 07/05/23.
//

import Foundation
import CoreLocation
import MapKit

class CheckoutViewModel: ObservableObject {
    // Create an instance of LocationManager to retrieve the user's location
    private let locationManager = LocationManager()
    
    // Declare two @Published properties to update the UI when the location or areaString changes
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var areaString: String?
    
    // Function to refresh the user's location
    func refreshLocation() {
        // Execute the code on a background thread with high priority to prevent the UI from freezing
        DispatchQueue.global(qos: .userInitiated).async {
            // Call the getCurrentLocation function of LocationManager to get the user's current location
            self.locationManager.getCurrentLocation { result in
                switch result {
                case .success(let location):
                    // If the location is retrieved successfully, call the getAreaString function of LocationManager to get the user's area as a string
                    self.locationManager.getAreaString(from: location) { area, error in
                        if let area = area {
                            // If the area is retrieved successfully, update the areaString property to display it on the UI
                            self.areaString = area
                        }
                    }
                    // Update the currentLocation property to display the user's location on the UI
                    self.currentLocation = location.coordinate
                    
                case .failure(let error):
                    // If there is an error in retrieving the location, print the error to the console
                    print(error.localizedDescription)
                }
            }
        }
    }
}
