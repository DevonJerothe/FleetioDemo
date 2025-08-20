//
//  MapViewSheet.swift
//  FleetioDemo
//
//  Created by devon jerothe on 8/20/25.
//

import SwiftUI
import MapKit

public struct MapViewSheet: View {
    let lastLocation: LocationEntry
    var coordinate: CLLocationCoordinate2D?
    
    @State private var position: MapCameraPosition
    
    init(
        lastLocation: LocationEntry
    ) {
        self.lastLocation = lastLocation
        if let lat = lastLocation.geolocation?.latitude, let long = lastLocation.geolocation?.longitude {
            let mapCoordinate = CLLocationCoordinate2D(
                latitude: lat,
                longitude: long
            )
            self.coordinate = mapCoordinate
            
            let currRegion = MKCoordinateRegion(
                center: mapCoordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
            
            self._position = State(initialValue: MapCameraPosition.region(currRegion))
        } else {
            
            // Defaults to a regular world view so that we dont need to implement location permissions.
            let defaultRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
            )
            self._position = State(initialValue: MapCameraPosition.region(defaultRegion))
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Map(position: $position) {
                if let coordinate {
                    Marker("last location", coordinate: coordinate)
                }
            }
            .frame(height: 250)
            .padding(.bottom, 8)
            
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Text("Address")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(lastLocation.address ?? "No Address Found")
                    .font(.subheadline)
                Divider()
                Text("Date")
                Text(lastLocation.date?.toDateString() ?? "No Date Found")
            }
            .padding(.horizontal, 16)

            Spacer()
        }
        .ignoresSafeArea(.container)
    }
}
