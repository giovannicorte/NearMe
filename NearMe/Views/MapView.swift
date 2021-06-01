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
            InfoView(place: place)
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
                Text(Constants.Titles.back)
                    .foregroundColor(.white)
            }
        }))
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            model.loadRegion(placeLocation: place.location, userLocation: location)
        })
    }
}

struct InfoView: View {
    let place: Place
    
    var body: some View {
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
                Text(Constants.Titles.noAddress)
                    .font(.caption)
            }
            Text("Distance: \(place.distance.distanceInKm().description) km")
                .font(.caption)
            Button(action: {
                openMapsAppWithDirections(to: place.getCoordinates(), destinationName: place.name)
            }, label: {
                HStack {
                    Text(Constants.Titles.openInMaps)
                    Image(systemName: "map")
                        .imageScale(.large)
                }
            })
        }
        .padding(20)
        .frame(minWidth: 0, minHeight: 0)
        .background(Color.white
                        .shadow(color: Color.gray, radius: 3, x: 0, y: 0))
        .offset(x: 0, y: 200)
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String) {
      let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
      let mapItem = MKMapItem(placemark: placemark)
      mapItem.name = name
        mapItem.openInMaps(launchOptions: options)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: TestData.place, location: TestData.place.location)
    }
}
