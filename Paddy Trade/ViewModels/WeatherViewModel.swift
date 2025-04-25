//
//  WeatherViewModel.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-25.
//

import Foundation
import Foundation
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject {
    @Published var weather: WeatherData?
    @Published var locationName = "Your Location"

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func fetchWeather() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    private func getWeather(for location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        let apiKey = "8e542a88fcc3216487d7c4caae05b728"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            if let decoded = try? JSONDecoder().decode(OpenWeatherResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.weather = WeatherData(
                        temperature: decoded.main.temp,
                        condition: decoded.weather.first?.main ?? "N/A",
                        windSpeed: decoded.wind.speed,
                        humidity: decoded.main.humidity
                    )
                    self.locationName = decoded.name
                }
            }
        }.resume()
    }
}

extension WeatherViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getWeather(for: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
