//
//  Endpoint.swift
//  NearMe
//
//  Created by Giovanni Corte on 26/05/2021.
//

import Foundation

protocol Endpoint {
    
    var scheme: String { get }
    
    var baseUrl: String { get }
    
    var path: String { get }
    
    var parameters: [URLQueryItem] { get }
    
    var method: String { get }
    
}
