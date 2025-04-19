//
//  WeatherViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-19.
//

import Foundation
import SwiftUI
import CoreLocation
import WeatherKit
import MapKit

@MainActor
class WeatherViewModel: NSObject, ObservableObject {
    @Published var weather: Weather?
        @Published var locationName: String = "Current Location"
        @Published var searchQuery = ""
        @Published var searchResults: [MKLocalSearchCompletion] = []

        private let weatherService = WeatherService()
        private let locationManager = CLLocationManager()
        
        private lazy var completer: MKLocalSearchCompleter = {
            let c = MKLocalSearchCompleter()
            c.resultTypes = .address
            c.delegate = self
            return c
        }()

        override init() {
            super.init()
            requestLocation()
        }

        func updateSearchResults() {
            completer.queryFragment = searchQuery
        }
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(),
           let location = locationManager.location {
            Task {
                await fetchWeather(for: location)
            }
        }
    }

    func fetchWeather(for location: CLLocation) async {
        do {
            let weather = try await weatherService.weather(for: location)
            self.weather = weather

            let geocoder = CLGeocoder()
            if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
                self.locationName = placemark.locality ?? "Selected Location"
            }
        } catch {
            print("Error fetching weather: \(error)")
        }
    }



    func selectLocation(completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)

        search.start { [weak self] response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            Task {
                await self?.fetchWeather(for: location)
            }
        }
        searchQuery = ""
        searchResults = []
    }
}

extension WeatherViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}


