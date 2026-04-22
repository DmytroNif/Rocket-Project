//
//  WmoWeatherInfo.swift
//  Rocket-Project
//
//  WMO weather interpretation codes (Open-Meteo / WMO).
//

import Foundation

enum WmoWeatherInfo: Sendable {
    /// Returns human-readable labels and an SF Symbol for the current conditions.
    static func forCode(_ code: Int) -> (main: String, description: String, systemIcon: String) {
        switch code {
        case 0:
            return (main: "Clear", description: "Clear sky", systemIcon: "sun.max.fill")
        case 1:
            return (main: "Mainly clear", description: "Mainly clear", systemIcon: "cloud.sun.fill")
        case 2:
            return (main: "Partly cloudy", description: "Partly cloudy", systemIcon: "cloud.sun.fill")
        case 3:
            return (main: "Overcast", description: "Overcast", systemIcon: "cloud.fill")
        case 45, 48:
            return (main: "Fog", description: "Fog", systemIcon: "cloud.fog.fill")
        case 51, 53, 55:
            return (main: "Drizzle", description: "Drizzle", systemIcon: "cloud.drizzle.fill")
        case 56, 57:
            return (main: "Freezing drizzle", description: "Freezing drizzle", systemIcon: "cloud.sleet.fill")
        case 61, 63, 65:
            return (main: "Rain", description: "Rain", systemIcon: "cloud.rain.fill")
        case 66, 67:
            return (main: "Freezing rain", description: "Freezing rain", systemIcon: "cloud.sleet.fill")
        case 71, 73, 75:
            return (main: "Snow", description: "Snow fall", systemIcon: "cloud.snow.fill")
        case 77:
            return (main: "Snow", description: "Snow grains", systemIcon: "cloud.snow.fill")
        case 80, 81, 82:
            return (main: "Showers", description: "Rain showers", systemIcon: "cloud.heavyrain.fill")
        case 85, 86:
            return (main: "Snow showers", description: "Snow showers", systemIcon: "cloud.snow.fill")
        case 95:
            return (main: "Thunderstorm", description: "Thunderstorm", systemIcon: "cloud.bolt.rain.fill")
        case 96, 99:
            return (main: "Thunderstorm", description: "Thunderstorm with hail", systemIcon: "cloud.bolt.rain.fill")
        default:
            return (main: "Other", description: "Weather code \(code)", systemIcon: "cloud.fill")
        }
    }
}
