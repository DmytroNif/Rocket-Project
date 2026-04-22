//
//  NoteDetailView.swift
//  Rocket-Project
//

import SwiftUI

struct NoteDetailView: View {
    let note: WeatherNote

    private var timeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: note.createdAt)
    }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(note.text)
                        .font(.title3.weight(.semibold))
                    Text(timeText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .listRowBackground(Color.clear)
            }

            Section(String(localized: "Weather")) {
                HStack {
                    WeatherIconView(weather: note.weather, size: 72)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(String(format: "%.0f°", note.weather.temperatureCelsius))
                            .font(.title.weight(.semibold))
                        Text(note.weather.conditionDescription.capitalized)
                            .foregroundStyle(.secondary)
                        Text(note.weather.conditionMain)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                }
            }

            Section(String(localized: "Location")) {
                Text(note.weather.locationName)
                HStack {
                    Text(String(localized: "Coordinates"))
                    Spacer()
                    Text(String(format: "%.4f, %.4f", note.weather.latitude, note.weather.longitude))
                        .font(.caption.monospaced())
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(String(localized: "Note"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(
            note: WeatherNote(
                id: UUID(),
                text: "Пробіжка",
                createdAt: .now,
                weather: WeatherSnapshot(
                    temperatureCelsius: 5,
                    conditionDescription: "clear sky",
                    conditionMain: "Clear",
                    iconId: "01n",
                    locationName: "Kyiv",
                    latitude: 50.45,
                    longitude: 30.52,
                    iconSystemName: nil
                )
            )
        )
    }
}
