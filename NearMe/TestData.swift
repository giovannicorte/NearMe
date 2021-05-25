//
//  TestData.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import SwiftUI

struct TestData {
    static let place: Place = {
        let json: String =
            """
            {
                "id": "N4424271186",
                "location": {
                    "coordinates": [12.1838183, 42.1083156],
                    "type": "Point"
                },
                "name": "Movida Beach",
                "desc": "Food bar",
                "address": "Lungolago Giuseppe Argenti",
                "town": "None",
                "distance": 1625.7303465635484
            }
            """
        let data = json.data(using: .utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try! decoder.decode(Place.self, from: data!)
    }()
}
