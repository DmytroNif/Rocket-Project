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
                if let url = note.weather.iconImageURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 40, height: 40)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        case .failure:
                            Image(systemName: "cloud.sun.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "cloud.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
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
                    conditionDescription: "легка хмарність",
                    conditionMain: "Clouds",
                    iconId: "02d",
                    locationName: "Kyiv",
                    latitude: 50.45,
                    longitude: 30.52
                )
            )
        )
    }
}
