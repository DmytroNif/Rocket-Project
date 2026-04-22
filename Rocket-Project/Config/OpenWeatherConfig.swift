//
//  OpenWeatherConfig.swift
//  Rocket-Project
//
//  Add your key from https://openweathermap.org/api (Current Weather 2.5 is free).
//

import Foundation

enum OpenWeatherConfig {
    /// Optional: paste your key here, or set OPENWEATHER_API_KEY in the scheme’s Environment Variables.
    private static let embeddedAPIKey = ""

    static var apiKey: String {
        if let fromEnv = ProcessInfo.processInfo.environment["OPENWEATHER_API_KEY"], !fromEnv.isEmpty {
            return fromEnv
        }
        return embeddedAPIKey
    }

    static let defaultCity = "Kyiv"
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
}
