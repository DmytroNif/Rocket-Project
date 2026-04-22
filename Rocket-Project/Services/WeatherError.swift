//
//  WeatherError.swift
//  Rocket-Project
//

import Foundation

enum WeatherError: LocalizedError, Equatable, Sendable {
    case invalidRequest
    case noData
    case httpStatus(code: Int)
    case networkUnavailable
    case decodingFailed
    case noWeatherPayload
    case locationNotFound

    var errorDescription: String? {
        switch self {
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
        case .locationNotFound:
            return "No place matched that name. Try another spelling or a larger city."
        }
    }
}
