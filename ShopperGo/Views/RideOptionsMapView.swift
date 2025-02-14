//
//  RideOptionsMapView.swift
//  ShopperGo
//
//  Created by Ricardo Altavista on 13/02/25.
//

import SwiftUI
import MapKit

struct MapMarkerItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct RideOptionsMapView: View {
    let origin: CLLocationCoordinate2D
    let destination: CLLocationCoordinate2D
    
    @State private var region: MKCoordinateRegion

    init(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        self.origin = origin
        self.destination = destination
        
        let center = CLLocationCoordinate2D(
            latitude: (origin.latitude + destination.latitude) / 2,
            longitude: (origin.longitude + destination.longitude) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: abs(origin.latitude - destination.latitude) * 2,
            longitudeDelta: abs(origin.longitude - destination.longitude) * 2
        )
        _region = State(initialValue: MKCoordinateRegion(center: center, span: span))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [MapMarkerItem(coordinate: origin), MapMarkerItem(coordinate: destination)]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
        .frame(height: 200)
        .cornerRadius(10)
        .padding()
    }
}

struct RideOptionsMapView_Previews: PreviewProvider { static var previews: some View {
    RideOptionsMapView( origin: CLLocationCoordinate2D(latitude: -23.5215624, longitude: -46.7632867), destination: CLLocationCoordinate2D(latitude: -23.5615351, longitude: -46.6562816) ) } }
