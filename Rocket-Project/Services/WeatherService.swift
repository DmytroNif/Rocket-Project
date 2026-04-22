//
//  WeatherService.swift
//  Rocket-Project
//

import Foundation

protocol WeatherServiceProtocol: Sendable {
    func fetchCurrentWeather(city: String) async throws -> WeatherSnapshot
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot
}

struct WeatherService: WeatherServiceProtocol {
    private let session: URLSession
    private let baseURL: String

    init(session: URLSession = .shared, baseURL: String = OpenWeatherConfig.baseURL) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchCurrentWeather(city: String) async throws -> WeatherSnapshot {
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: OpenWeatherConfig.apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        return try await fetch(using: components)
    }

    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot {
        var components = URLComponents(string: baseURL)
        let latStr = String(format: "%.4f", latitude)
        let lonStr = String(format: "%.4f", longitude)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: latStr),
            URLQueryItem(name: "lon", value: lonStr),
            URLQueryItem(name: "appid", value: OpenWeatherConfig.apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        return try await fetch(using: components)
    }

    private func fetch(using components: URLComponents?) async throws -> WeatherSnapshot {
        if OpenWeatherConfig.apiKey.isEmpty {
            throw WeatherError.missingAPIKey
        }
        guard let url = components?.url else {
            throw WeatherError.invalidRequest
        }
        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse else {
                throw WeatherError.noData
            }
            guard (200 ... 299).contains(http.statusCode) else {
                throw WeatherError.httpStatus(code: http.statusCode)
            }
            if data.isEmpty {
                throw WeatherError.noData
            }
            let decoded: OpenWeatherResponse
            do {
                decoded = try JSONDecoder().decode(OpenWeatherResponse.self, from: data)
            } catch {
                throw WeatherError.decodingFailed
            }
            guard let snapshot = decoded.toSnapshot() else {
                throw WeatherError.noWeatherPayload
            }
            return snapshot
        } catch let weather as WeatherError {
            throw weather
        } catch let urlError as URLError {
            if urlError.code == .notConnectedToInternet
                || urlError.code == .networkConnectionLost
                || urlError.code == .dataNotAllowed
            {
                throw WeatherError.networkUnavailable
            }
            throw urlError
        } catch {
            throw error
        }
    }
}
