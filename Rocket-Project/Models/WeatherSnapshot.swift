//
//  WeatherSnapshot.swift
//  Rocket-Project
//

import Foundation

/// Current weather for a point in time, suitable for display and local persistence.
struct WeatherSnapshot: Codable, Equatable, Sendable {
    var temperatureCelsius: Double
    var conditionDescription: String
    var conditionMain: String
    var iconId: String
    var locationName: String
    var latitude: Double
    var longitude: Double
}

extension WeatherSnapshot {
    var iconImageURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
    }

    var compactSummary: String {
        let t = String(format: "%.0f", temperatureCelsius)
        return "\(t)° · \(conditionDescription.capitalized)"
    }
}
