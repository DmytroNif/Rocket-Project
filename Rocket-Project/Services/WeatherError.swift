//
//  WeatherError.swift
//  Rocket-Project
//

import Foundation

enum WeatherError: LocalizedError, Equatable, Sendable {
    case missingAPIKey
    case invalidRequest
    case noData
    case httpStatus(code: Int)
    case networkUnavailable
    case decodingFailed
    case noWeatherPayload

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "Add your OpenWeather API key in OpenWeatherConfig or set OPENWEATHER_API_KEY in the run scheme."
        case .invalidRequest:
            return "Could not build the weather request."
        case .noData:
            return "The server returned no data."
        case .httpStatus(let code):
            return "Weather service returned an error (HTTP \(code))."
        case .networkUnavailable:
            return "No network connection. Check Wi‑Fi or cellular and try again."
        case .decodingFailed:
            return "Could not read the weather response."
        case .noWeatherPayload:
            return "The response did not include weather details."
        }
    }
}
