//
//  WeatherIconView.swift
//  Rocket-Project
//

import SwiftUI

struct WeatherIconView: View {
    let weather: WeatherSnapshot
    var size: CGFloat = 40

    private var a11yLabel: String {
        String(
            format: String(localized: "%1$@, %2$.0f degrees"),
            weather.conditionDescription,
            weather.temperatureCelsius
        )
    }

    var body: some View {
        if let name = weather.iconSystemName {
            Image(systemName: name)
                .font(.system(size: size * 0.6))
                .frame(width: size, height: size)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.primary)
                .accessibilityLabel(a11yLabel)
        } else if let url = weather.iconImageURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: size, height: size)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .accessibilityLabel(a11yLabel)
                case .failure:
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: size * 0.5))
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(a11yLabel)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "cloud.fill")
                .font(.system(size: size * 0.5))
                .foregroundStyle(.secondary)
                .accessibilityLabel(a11yLabel)
        }
    }
}
