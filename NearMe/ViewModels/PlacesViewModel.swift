//
//  PlacesViewModel.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import CoreLocation
import Combine

class PlacesViewModel: NSObject, ObservableObject {
    @Published var places: [Place] = [Place]()
    @Published var isLoading: Bool = false
    private var page: Int = 0
    private var canLoadMorePages: Bool = true
    
    @Published var authorizationDenied: Bool = false
    var locationManager: CLLocationManager = CLLocationManager()
    var lastLocation: Location?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func loadMoreContent(currentItem place: Place?) {
        guard let place = place else {
            loadContent()
            return
        }
        
        let thresholdIndex = places.index(places.endIndex, offsetBy: -5)
        if places.firstIndex(where: { $0.id == place.id }) == thresholdIndex {
            loadContent()
        }
    }
    
    func invalidate() {
        if isLoading {
            return
        }
        isLoading = false
        places = []
        page = 0
        canLoadMorePages = true
        lastLocation = nil
    }
    
    func loadContent() {
        if isLoading {
            return
        }
        if lastLocation != nil {
            self.fetchPlaces(latitude: lastLocation!.coordinates[1], longitude: lastLocation!.coordinates[0])
        } else {
            locationManager.requestLocation()
        }
    }
    
    func fetchPlaces(latitude: Double, longitude: Double) {
        guard !isLoading && canLoadMorePages else {
            return
        }
        isLoading = true
        
        NetworkEngine.request(
            endpoint: PlacesEndpoint.places(query: "all", latitude: latitude, longitude: longitude, page: page)) {
            (result : Result<Places, Error>) in
            switch result {
            case .success(let response):
                self.page += 1
                self.isLoading = false
                self.places.append(contentsOf: response.places)
                if response.places.count < 10 {
                    self.canLoadMorePages = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension PlacesViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.first!
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.lastLocation = Location(coordinates: [longitude, latitude], type: "Point")
        
        self.fetchPlaces(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse || status == .authorizedAlways) {
            manager.requestLocation()
        } else if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            self.authorizationDenied = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Implement error handling
    }
    
}
