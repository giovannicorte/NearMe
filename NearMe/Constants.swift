//
//  Constants.swift
//  NearMe
//
//  Created by Giovanni Corte on 01/06/2021.
//

import Foundation

struct Constants {
    
    struct Errors {
        static let authorizationErrorTitle = "Authorization Required"
        static let authorizationErrorText = "You have to give localization permissions in order to use this appplication. Go to Settings -> Privacy -> Location and enable it."
        
        static let emptyErrorTitle = "No results"
        static let emptyErrorText = "You haven't interesting places around you"
        
        static let unknownErrorTitle = "Error"
        static let unknownErrorText = "An unknown error occurred"
    }
    
    struct Titles {
        static let settings = "Settings"
        static let filter = "Filter by"
        static let title = "Places"
        static let openInMaps = "Open in maps"
        static let noAddress = "Address information not available"
        static let back = "Back"
    }
}
