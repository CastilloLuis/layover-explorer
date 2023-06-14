//
//  MapPreview.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/14/23.
//

import SwiftUI
import MapKit

struct MapPreview: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
}

struct MapPreview_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapPreviewView: View {
    let coordinate = CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
    
    var body: some View {
        MapPreview(coordinate: coordinate)
    }
}
