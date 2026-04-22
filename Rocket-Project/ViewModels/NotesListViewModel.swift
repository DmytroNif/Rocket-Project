//
//  NotesListViewModel.swift
//  Rocket-Project
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class NotesListViewModel {
    var notes: [WeatherNote] = []
    var loadError: String?

    private let storage: NoteStorageService

    init() {
        self.storage = NoteStorageService()
    }

    /// For tests or previews with an isolated `UserDefaults` suite.
    init(storage: NoteStorageService) {
        self.storage = storage
    }

    func load() {
        loadError = nil
        let loaded = storage.loadNotes()
        notes = loaded.sorted { $0.createdAt > $1.createdAt }
    }

    func deleteNotes(at indexSet: IndexSet) {
        var copy = notes
        for index in indexSet.sorted(by: >) {
            copy.remove(at: index)
        }
        notes = copy
        persist()
    }

    private func persist() {
        do {
            try storage.saveNotes(notes)
        } catch {
            loadError = String(localized: "Could not save changes.")
        }
    }
}
