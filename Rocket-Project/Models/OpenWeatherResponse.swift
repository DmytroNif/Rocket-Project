//
//  OpenWeatherResponse.swift
//  Rocket-Project
//
//  Decoding types for https://api.openweathermap.org/data/2.5/weather
//

import Foundation

struct OpenWeatherResponse: Decodable, Sendable {
    let name: String
    let coord: Coordinates
    let weather: [WeatherItem]
    let main: MainBlock

    struct Coordinates: Decodable, Sendable {
        let lat: Double
        let lon: Double
    }

    struct WeatherItem: Decodable, Sendable {
        let main: String
        let description: String
        let icon: String
    }

    struct MainBlock: Decodable, Sendable {
        let temp: Double
    }

    func toSnapshot() -> WeatherSnapshot? {
        guard let w = weather.first else { return nil }
        return WeatherSnapshot(
            temperatureCelsius: main.temp,
            conditionDescription: w.description,
            conditionMain: w.main,
            iconId: w.icon,
            locationName: name,
            latitude: coord.lat,
            longitude: coord.lon
        )
    }
}
