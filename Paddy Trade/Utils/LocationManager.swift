//
//  LocationManager.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-18.
//

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
    static let shared = LocationManager() // Singleton instance

    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?

    // For one-time location fetch
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

    // MARK: - Continuous Location Updates
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

    // MARK: - One-time Location Request (e.g. for map, weather card)
    func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        singleLocationCompletion = completion
        manager.requestLocation()
    }
}
