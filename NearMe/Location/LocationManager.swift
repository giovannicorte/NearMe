//
//  LocationManager.swift
//  NearMe
//
//  Created by Giovanni Corte on 03/06/2021.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject {
    var locationManager = CLLocationManager()
    var callbacks = [(Result<Location, PlacesError>) -> ()]()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getLocation(completion: @escaping (Result<Location, PlacesError>) -> ()) {
        callbacks.append(completion)
        guard locationManager.authorizationStatus != .denied else {
            completion(.failure(.authorization))
            return
        }
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let lastLocation = Location(coordinates: [longitude, latitude], type: "Point")
        for completion in callbacks { completion(.success(lastLocation)) }
        callbacks.removeAll()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.requestLocation()
        case .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            for completion in callbacks { completion(.failure(PlacesError.authorization)) }
            callbacks.removeAll()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        for completion in callbacks {
            completion(.failure(PlacesError.unknown))
        }
        callbacks.removeAll()
    }
}
