//
//  NoteRowView.swift
//  Rocket-Project
//

import SwiftUI

struct NoteRowView: View {
    let note: WeatherNote

    private var timeText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: note.createdAt)
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                Text(timeText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .trailing, spacing: 2) {
                WeatherIconView(weather: note.weather, size: 40)
                Text(String(format: "%.0f°", note.weather.temperatureCelsius))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    List {
        NoteRowView(
            note: WeatherNote(
                id: UUID(),
                text: "Прогулянка в парку",
                createdAt: .now,
                weather: WeatherSnapshot(
                    temperatureCelsius: 18,
                    conditionDescription: "Partly cloudy",
                    conditionMain: "Partly cloudy",
                    iconId: "02d",
                    locationName: "Kyiv",
                    latitude: 50.45,
                    longitude: 30.52,
                    iconSystemName: nil
                )
            )
        )
    }
}
