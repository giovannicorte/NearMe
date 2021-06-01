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
    @Published var error: PlacesError = .none
    
    private var query: String = "all"
    private var page: Int = 0
    private var canLoadMorePages: Bool = true

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
    
    func invalidate(query: String = "all") {
        if isLoading {
            return
        }
        self.isLoading = false
        self.places = []
        self.page = 0
        self.canLoadMorePages = true
        self.lastLocation = nil
        self.query = query
    }
    
    func loadContent() {
        if isLoading { return }
        self.isLoading = true
        if lastLocation != nil && canLoadMorePages {
            self.fetchPlaces(latitude: lastLocation!.coordinates[1], longitude: lastLocation!.coordinates[0])
        } else {
            self.locationManager.requestLocation()
        }
    }
    
    func fetchPlaces(latitude: Double, longitude: Double) {
        NetworkEngine.request(
            endpoint: PlacesEndpoint.places(query: query, latitude: latitude, longitude: longitude, page: page)) {
            (result : Result<Places, Error>) in
            switch result {
            case .success(let response):
                if (response.places.count == 0) {
                    self.isLoading = false
                    self.error = .empty
                    return
                }
                self.page += 1
                self.isLoading = false
                self.places.append(contentsOf: response.places)
                if response.places.count < 10 {
                    self.canLoadMorePages = true
                }
            case .failure(let error):
                print(error)
                self.error = .unknown
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
        self.isLoading = true
        self.fetchPlaces(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedWhenInUse || status == .authorizedAlways) {
            manager.requestLocation()
        } else if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            self.error = .authorization
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = .location
    }
}

enum PlacesError {
    case none
    case empty
    case location
    case unknown
    case authorization
}
