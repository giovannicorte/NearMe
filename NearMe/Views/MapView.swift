//
//  MapView.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    let place: Place
    let location: Location
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var model = MapViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $model.region,
                showsUserLocation: true,
                annotationItems: [self.place]) { place in
                MapMarker(coordinate: place.getCoordinates())
            }
            PlaceView(place: place)
                .frame(width: 300, height: 175)
                .background(Color.white
                                .shadow(color: Color.gray, radius: 3, x: 0, y: 0))
                .offset(x: 0, y: 200)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(place.name)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.white)
                    .imageScale(.medium)
                Text("Back")
                    .foregroundColor(.white)
            }
        }))
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            model.loadRegion(placeLocation: place.location, userLocation: location)
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: TestData.place, location: TestData.place.location)
    }
}
