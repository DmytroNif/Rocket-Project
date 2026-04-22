//
//  WeatherService.swift
//  Rocket-Project
//
//  Open-Meteo over URLSession (JSON). No API key. Docs: https://open-meteo.com/en/docs
//

import Foundation

protocol WeatherServiceProtocol: Sendable {
    func fetchCurrentWeather(city: String) async throws -> WeatherSnapshot
    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot
}

struct WeatherService: WeatherServiceProtocol {
    private let session: URLSession

    private static let forecastBase = "https://api.open-meteo.com/v1/forecast"
    private static let geocodeBase = "https://geocoding-api.open-meteo.com/v1/search"

    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Resolves the city name via Open-Meteo geocoding, then fetches current weather.
    func fetchCurrentWeather(city: String) async throws -> WeatherSnapshot {
        let name = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { throw WeatherError.invalidRequest }

        var geo = URLComponents(string: Self.geocodeBase)
        geo?.queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "count", value: "5"),
            URLQueryItem(name: "language", value: "en")
        ]
        guard let geocodeURL = geo?.url else { throw WeatherError.invalidRequest }

        let (geoData, geoResponse) = try await session.data(from: geocodeURL)
        guard let geoHttp = geoResponse as? HTTPURLResponse else { throw WeatherError.noData }
        guard (200 ... 299).contains(geoHttp.statusCode) else {
            throw WeatherError.httpStatus(code: geoHttp.statusCode)
        }

        let geoDecoded: OpenMeteoGeocodingResponse
        do {
            geoDecoded = try JSONDecoder().decode(OpenMeteoGeocodingResponse.self, from: geoData)
        } catch {
            throw WeatherError.decodingFailed
        }
        guard let first = geoDecoded.results?.first else {
            throw WeatherError.locationNotFound
        }

        var display = first.name
        if let country = first.country {
            display = "\(first.name), \(country)"
        }
        return try await loadSnapshot(
            latitude: first.latitude,
            longitude: first.longitude,
            locationName: display
        )
    }

    func fetchCurrentWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot {
        let label = "Coordinates: \(String(format: "%.4f", latitude)), \(String(format: "%.4f", longitude))"
        return try await loadSnapshot(
            latitude: latitude,
            longitude: longitude,
            locationName: label
        )
    }

    private func loadSnapshot(
        latitude: Double,
        longitude: Double,
        locationName: String
    ) async throws -> WeatherSnapshot {
        var comp = URLComponents(string: Self.forecastBase)
        comp?.queryItems = [
            URLQueryItem(name: "latitude", value: String(format: "%.4f", latitude)),
            URLQueryItem(name: "longitude", value: String(format: "%.4f", longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code"),
            URLQueryItem(name: "timezone", value: "auto")
        ]
        guard let url = comp?.url else { throw WeatherError.invalidRequest }

        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse else { throw WeatherError.noData }
            guard (200 ... 299).contains(http.statusCode) else {
                throw WeatherError.httpStatus(code: http.statusCode)
            }
            if data.isEmpty { throw WeatherError.noData }

            let decoded: OpenMeteoForecastResponse
            do {
                decoded = try JSONDecoder().decode(OpenMeteoForecastResponse.self, from: data)
            } catch {
                throw WeatherError.decodingFailed
            }
            guard let current = decoded.current else { throw WeatherError.noWeatherPayload }

            let wmo = WmoWeatherInfo.forCode(current.weather_code)
            return WeatherSnapshot(
                temperatureCelsius: current.temperature_2m,
                conditionDescription: wmo.description,
                conditionMain: wmo.main,
                iconId: "",
                locationName: locationName,
                latitude: decoded.latitude,
                longitude: decoded.longitude,
                iconSystemName: wmo.systemIcon
            )
        } catch let e as WeatherError {
            throw e
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
