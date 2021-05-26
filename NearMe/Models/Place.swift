//
//  Place.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import SwiftUI
import MapKit

struct Places {
    let places: [Place]
}

struct Place: Identifiable {
    let id: String
    let location: Location
    let name: String
    let tag: String
    let address: String
    let town: String
    let distance: Double
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.location.coordinates[1], longitude: self.location.coordinates[0])
    }
    
}

struct Location {
    let coordinates: [Double]
    let type: String
}

extension Places: Codable {
    enum CodingKeys: String, CodingKey {
        case places
    }
}

extension Place: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, address, town, distance, location
        case tag = "desc"
    }
}

extension Location: Codable {
    enum CodingKeys: String, CodingKey {
        case coordinates, type
    }
}

extension Place {
    var iconResource: String {
        let s: String = self.tag.lowercased()
        if s.contains("food") {
            return "restaurant"
        } else if s.contains("shop") {
            return "shop"
        } else if s.contains("monument") {
            return "monument"
        } else if s.contains("money") {
            return "bank"
        } else if s.contains("sport") && !s.contains("transport") {
            return "sport"
        } else {
            return "marker"
        }
    }
}
