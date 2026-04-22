//
//  AddNoteViewModel.swift
//  Rocket-Project
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class AddNoteViewModel {
    var text = ""
    var isLoading = false
    var errorMessage: String?

    private let weatherService: any WeatherServiceProtocol
    private let storage: NoteStorageService

    init() {
        self.weatherService = WeatherService()
        self.storage = NoteStorageService()
    }

    init(weatherService: any WeatherServiceProtocol, storage: NoteStorageService) {
        self.weatherService = weatherService
        self.storage = storage
    }

    var canSave: Bool {
        !trimmedText.isEmpty && !isLoading
    }

    private var trimmedText: String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    @discardableResult
    func save() async -> Bool {
        let body = trimmedText
        guard !body.isEmpty else { return false }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let snapshot = try await weatherService.fetchCurrentWeather(city: OpenWeatherConfig.defaultCity)
            let note = WeatherNote(
                id: UUID(),
                text: body,
                createdAt: Date(),
                weather: snapshot
            )
            try storage.addNote(note)
            return true
        } catch let weather as WeatherError {
            errorMessage = weather.localizedDescription
            return false
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
