//
//  PlacesEndpoint.swift
//  NearMe
//
//  Created by Giovanni Corte on 26/05/2021.
//

import Foundation

enum PlacesEndpoint: Endpoint {
    
    case places(query: String, latitude: Double, longitude: Double, page: Int)
    
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var baseUrl: String {
        switch self {
        default:
            return "nearme-py-webapp.herokuapp.com"
        }
    }
    
    var path: String {
        switch self {
        case .places:
            return "/places"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .places(let query, let latitude, let longitude, let page):
            return [URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "latitude", value: String(latitude)),
                    URLQueryItem(name: "longitude", value: String(longitude)),
                    URLQueryItem(name: "page", value: String(page))
            ]
        }
    }
        
    var method: String {
        switch self {
        case .places:
            return "GET"
        }
    }
    
    
}
