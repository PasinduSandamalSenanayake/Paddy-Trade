//
//  Weather.swift
//  Paddy Trade
//
//  Created by Sandamal on 2025-04-25.
//

import Foundation
struct OpenWeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String

    struct Weather: Codable {
        let main: String
    }

    struct Main: Codable {
        let temp: Double
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
    }
}

struct WeatherData {
    let temperature: Double
    let condition: String
    let windSpeed: Double
    let humidity: Int
}
