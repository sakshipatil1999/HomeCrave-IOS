//
//  LocationManager.swift
//  HomeCrave
//
//  Created by Sakshi Patil on 02/05/23.
//

import Foundation
import CoreLocation
import Firebase

class LocationManager: NSObject, CLLocationManagerDelegate {
    // Location Manager instance
    private let locationManager = CLLocationManager()
    // Callback to provide location data
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    // Firebase database reference
    let ref = Database.database().reference()
    
    override init() {
        super.init()
        // Set the location manager delegate to this class
        locationManager.delegate = self
        // Request user's permission to access their location
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Function to get the user's current location
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        // Check if location services are enabled
        guard CLLocationManager.locationServicesEnabled() else {
            // Return error if location services are not enabled
            completion(.failure(LocationError.locationServicesDisabled))
            return
        }
        
        // Handle location authorization status
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Request authorization if the user has not yet made a choice
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // Return error if the user has restricted or denied location access
            completion(.failure(LocationError.locationAccessDenied))
        case .authorizedAlways, .authorizedWhenInUse:
            // Set the completion handler and start updating location
            self.completion = completion
            locationManager.startUpdatingLocation()
        @unknown default:
            // Return error if unknown authorization status encountered
            completion(.failure(LocationError.unknownError))
        }
    }
    
    // Function to get the area string from the given location
    func getAreaString(from location: CLLocation, completion: @escaping (String?, Error?) -> Void) {
        // Initialize a geocoder object
        let geocoder = CLGeocoder()
        // Reverse geocode the given location to get the placemark
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            // Extract the locality (city name) from the placemark and return it
            guard let placemark = placemarks?.first, let area = placemark.locality else {
                completion(nil, error)
                return
            }
            completion(area, nil)
        }
    }
    
    // Function to calculate the distance between two locations
    func calculateDistance(from sourceLocation: CLLocation, to destinationLocation: CLLocation) -> String {
        // Calculate the distance between the two locations
        let distanceInMeters = sourceLocation.distance(from: destinationLocation)
        // Convert the distance to kilometers
        let distanceInKilometers = distanceInMeters / 1000
        // Format the distance as a string with two decimal places and "km" suffix
        return String(format: "%.2f km", distanceInKilometers)
    }
    
    // Delegate method called when the location manager updates the location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the most recent location from the list of locations
        guard let location = locations.last else { return }
        // Stop updating location and call the completion handler with the location data
        locationManager.stopUpdatingLocation()
        completion?(.success(location))
        completion = nil
    }
    
    // Delegate method called when the location manager fails to update the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Stop updating location and call the completion handler with the error
        locationManager.stopUpdatingLocation()
        completion?(.failure(error))
        completion = nil
    }
}

// Enum to represent possible location errors
enum LocationError: Error {
    case locationServicesDisabled
    case currentUserNotFound
    case locationNotFound
    case locationAccessDenied
    case unknownError
}
