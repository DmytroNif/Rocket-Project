//
//  NoteStorageService.swift
//  Rocket-Project
//
//  Persists notes in UserDefaults as JSON.
//

import Foundation

enum NoteStorageError: Error, Sendable {
    case encodingFailed
    case decodingFailed
}

@MainActor
final class NoteStorageService {
    private let key = "com.weathernotes.storedNotes.v1"
    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func loadNotes() -> [WeatherNote] {
        guard let data = defaults.data(forKey: key), !data.isEmpty else { return [] }
        do {
            return try decoder.decode([WeatherNote].self, from: data)
        } catch {
            return []
        }
    }

    func saveNotes(_ notes: [WeatherNote]) throws {
        do {
            let data = try encoder.encode(notes)
            defaults.set(data, forKey: key)
        } catch {
            throw NoteStorageError.encodingFailed
        }
    }

    /// Appends a note, preserving existing entries.
    func addNote(_ note: WeatherNote) throws {
        var all = loadNotes()
        all.append(note)
        try saveNotes(all)
    }
}
