//
//  PlacesError.swift
//  NearMe
//
//  Created by Giovanni Corte on 03/06/2021.
//

import Foundation

enum PlacesError: Error {
    case none
    case empty
    case location
    case unknown
    case authorization
}

extension PlacesError {
    public var title: String {
        switch self {
        case .authorization:
            return Constants.Errors.authorizationErrorTitle
        case .empty:
            return Constants.Errors.emptyErrorTitle
        case .unknown:
            return Constants.Errors.unknownErrorTitle
        default:
            return Constants.Errors.unknownErrorTitle
        }
    }
    
    public var description: String {
        switch self {
        case .authorization:
            return Constants.Errors.authorizationErrorText
        case .empty:
            return Constants.Errors.emptyErrorText
        case .unknown:
            return Constants.Errors.unknownErrorText
        default:
            return Constants.Errors.unknownErrorText
        }
    }
}
