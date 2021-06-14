//
//  PlacesViewModel.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import CoreLocation
import Combine

class PlacesViewModel: ObservableObject {
    @Published var places: [Place] = [Place]()
    @Published var loading: Bool = false
    @Published var error: PlacesError = .none
    
    private var query: String = "all"
    private var page: Int = 0
    private var canLoadMorePages: Bool = true
    
    var locationManager: LocationManager
    var lastLocation: Location?
    
    init(locationManager: LocationManager = .init()) {
        self.locationManager = locationManager
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
    
    func loadContent() {
        guard !loading && canLoadMorePages else {
            return
        }
        
        loading = true
        
        guard lastLocation != nil else {
            locationManager.getLocation { (result : Result<Location, PlacesError>) in
                switch result {
                case .success(let location):
                    self.lastLocation = location
                    self.loading = true
                    self.fetchPlaces(latitude: self.lastLocation!.coordinates[1], longitude: self.lastLocation!.coordinates[0])
                case .failure(let error):
                    self.loading = false
                    self.error = error
                }
            }
            return
        }
        fetchPlaces(latitude: lastLocation!.coordinates[1], longitude: lastLocation!.coordinates[0])
    }
    
    private func fetchPlaces(latitude: Double, longitude: Double) {
        NetworkEngine.request(
            endpoint: PlacesEndpoint.places(query: query, latitude: latitude, longitude: longitude, page: page)) {
            (result : Result<Places, Error>) in
            switch result {
            case .success(let response):
                if (response.places.count == 0) {
                    self.loading = false
                    self.error = .empty
                    return
                }
                self.page += 1
                self.loading = false
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
    
    func invalidate(query: String = "all") {
        guard !loading else {
            return
        }
        self.loading = false
        self.places = []
        self.page = 0
        self.canLoadMorePages = true
        self.lastLocation = nil
        self.query = query
    }
}
