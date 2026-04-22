//
//  NotesListView.swift
//  Rocket-Project
//

import SwiftUI

struct NotesListView: View {
    @State private var viewModel = NotesListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    ContentUnavailableView {
                        Label(String(localized: "No notes yet"), systemImage: "note.text")
                    } description: {
                        Text(String(localized: "Add a note from the add screen. Weather will be saved with each entry."))
                    }
                } else {
                    List {
                        ForEach(viewModel.notes) { note in
                            NavigationLink(value: note) {
                                NoteRowView(note: note)
                            }
                        }
                        .onDelete { viewModel.deleteNotes(at: $0) }
                    }
                }
            }
            .navigationTitle("WeatherNotes")
            .navigationDestination(for: WeatherNote.self) { note in
                NoteDetailView(note: note)
            }
            .onAppear { viewModel.load() }
            .alert(
                String(localized: "Storage error"),
                isPresented: Binding(
                    get: { viewModel.loadError != nil },
                    set: { if !$0 { viewModel.loadError = nil } }
                )
            ) {
                Button(String(localized: "OK"), role: .cancel) { viewModel.loadError = nil }
            } message: {
                if let m = viewModel.loadError { Text(m) }
            }
        }
    }
}

#Preview("Empty") {
    NotesListView()
}
