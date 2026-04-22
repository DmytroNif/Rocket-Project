//
//  WeatherIconView.swift
//  Rocket-Project
//

import SwiftUI

struct WeatherIconView: View {
    let weather: WeatherSnapshot
    var size: CGFloat = 40

    var body: some View {
        if let name = weather.iconSystemName {
            Image(systemName: name)
                .font(.system(size: size * 0.6))
                .frame(width: size, height: size)
                .symbolRenderingMode(.multicolor)
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
                case .failure:
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: size * 0.5))
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            Image(systemName: "cloud.fill")
                .font(.system(size: size * 0.5))
                .foregroundStyle(.secondary)
        }
    }
}
