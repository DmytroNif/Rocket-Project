//
//  WeatherSnapshot.swift
//  Rocket-Project
//

import Foundation

/// Current weather for a point in time, suitable for display and local persistence.
struct WeatherSnapshot: Codable, Equatable, Hashable, Sendable {
    var temperatureCelsius: Double
    var conditionDescription: String
    var conditionMain: String
    /// OpenWeather icon id (e.g. `01d`) for remote PNG; use when `iconSystemName` is nil.
    var iconId: String
    var locationName: String
    var latitude: Double
    var longitude: Double
    /// If set, show this SF Symbol instead of OpenWeather image (Open-Meteo + WMO).
    var iconSystemName: String? = nil
}

extension WeatherSnapshot {
    var iconImageURL: URL? {
        guard iconSystemName == nil, !iconId.isEmpty else { return nil }
        return URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png")
    }

    var compactSummary: String {
        let t = String(format: "%.0f", temperatureCelsius)
        return "\(t)° · \(conditionDescription.capitalized)"
    }
}
