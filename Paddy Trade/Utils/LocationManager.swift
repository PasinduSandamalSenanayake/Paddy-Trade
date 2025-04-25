//
//  LocationManager.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-18.
//

import CoreLocation
import Foundation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    private var singleLocationCompletion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latest = locations.first {
            location = latest.coordinate
            singleLocationCompletion?(latest)
            singleLocationCompletion = nil
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        singleLocationCompletion?(nil)
        singleLocationCompletion = nil
    }
    
    func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        singleLocationCompletion = completion
        manager.requestLocation()
    }
}
