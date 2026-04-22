//
//  OpenMeteoAPIModels.swift
//  Rocket-Project
//
//  See https://open-meteo.com/en/docs
//

import Foundation

// MARK: - Geocoding (https://open-meteo.com/en/docs/geocoding-api)

struct OpenMeteoGeocodingResponse: Decodable, Sendable {
    let results: [OpenMeteoGeocodingResult]?
}

struct OpenMeteoGeocodingResult: Decodable, Sendable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
}

// MARK: - Forecast (https://api.open-meteo.com/v1/forecast)

struct OpenMeteoForecastResponse: Decodable, Sendable {
    let latitude: Double
    let longitude: Double
    let current: OpenMeteoCurrent?
    let current_units: OpenMeteoCurrentUnits?
}

struct OpenMeteoCurrentUnits: Decodable, Sendable {
    let time: String?
    let temperature_2m: String?
    let weather_code: String?
}

struct OpenMeteoCurrent: Decodable, Sendable {
    let time: String
    let temperature_2m: Double
    let weather_code: Int
}
