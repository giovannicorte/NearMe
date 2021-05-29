//
//  PlaceView.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import SwiftUI

struct PlaceView: View {
    let place: Place
    
    var body: some View {
        HStack(alignment: .center, spacing: 8.0) {
            Image(place.iconResource)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32.0, height: 32.0)
            VStack(alignment: .leading, spacing: 4.0) {
                Text(place.name)
                    .font(.title)
                Text(place.tag)
                    .font(.body)
                    .foregroundColor(.orange)
                if place.address !=  "None" {
                    Text(place.address)
                        .font(.caption)
                } else {
                    Text("Address informations are not availables")
                        .font(.caption)
                }
                Text("Distance: \(place.distance.distanceInKm().description) km")
                    .font(.caption)
            }
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        let place: Place = TestData.place
        PlaceView(place: place)
    }
}

