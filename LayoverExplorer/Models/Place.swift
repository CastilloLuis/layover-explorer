// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(PlaceSuggested.self, from: jsonData)

import Foundation

// MARK: - PlaceSuggested
struct SuggestedPlace: Codable, Identifiable {
    let id = UUID()
    let name, description: String
    let website: String
    let timeCar, timeSubway: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case name, description, website
        case timeCar = "time_car"
        case timeSubway = "time_subway"
        case location
    }
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}
