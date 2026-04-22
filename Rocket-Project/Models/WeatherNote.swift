//
//  WeatherNote.swift
//  Rocket-Project
//

import Foundation

struct WeatherNote: Identifiable, Codable, Equatable, Hashable, Sendable {
    var id: UUID
    var text: String
    var createdAt: Date
    var weather: WeatherSnapshot
}
