//
//  MapViewModel.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import MapKit

class MapViewModel: NSObject, ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    func loadRegion(placeLocation: Location, userLocation: Location) -> Void {
        var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)

        [placeLocation, userLocation].forEach {
            topLeftCoord.longitude = fmin(topLeftCoord.longitude, $0.coordinates[0]);
            topLeftCoord.latitude = fmax(topLeftCoord.latitude, $0.coordinates[1]);
            bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, $0.coordinates[0]);
            bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, $0.coordinates[1]);
        }

        let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5, longitude: topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5)

        let span = MKCoordinateSpan(latitudeDelta: fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.3, longitudeDelta: fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.3)
        
        self.region = MKCoordinateRegion(center: center, span: span)
    }
}
