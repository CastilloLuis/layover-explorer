//
//  Suggestions.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/15/23.
//

import SwiftUI
import CoreLocation

struct Suggestions: View {
    @Binding var suggestions: [SuggestedPlace]

    func openMaps(_ latitude: Double, _ longitude: Double) {
        let urlString = "http://maps.apple.com/?ll=\(latitude),\(longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    var body: some View {
        VStack {
            Text("Custom plan!")
                .font(.headline)
            ScrollView {
                ForEach(suggestions, id: \.id) { place in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Text(place.description)
                                .font(.custom("Roboto-Regular", size: 12))
                                .lineLimit(3)
                                .truncationMode(.tail)
                            Text(place.website)
                                .font(.custom("Roboto-Regular", size: 10))
                                .foregroundColor(.blue)
                            Spacer()
                            Text("🚕 \(place.timeCar)")
                                .font(.custom("Roboto-Regular", size: 15))
                            Text("🚝 \(place.timeSubway)")
                                .font(.custom("Roboto-Regular", size: 15))
                        }
                        VStack {
                            MapPreview(coordinate:  CLLocationCoordinate2D(latitude: place.location.lat, longitude: place.location.lng))
                        }
                        .frame(width: 120, height: 100)
                        .cornerRadius(10)
                        .onTapGesture {
                            openMaps(place.location.lat, place.location.lng)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "FDFDFD"), Color(hex: "F4F4F4")]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(15)
                    .padding()
                    .shadow(color: Color.gray.opacity(0.25), radius: 10, x: 0, y: 2)
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding()
    }
}

struct Suggestions_Previews: PreviewProvider {
    static var previews: some View {
        Suggestions(suggestions: .constant([]))
    }
}
