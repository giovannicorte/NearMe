//
//  PlacesView.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import SwiftUI
import Combine

struct PlacesView: View {
    @StateObject var placesViewModel = PlacesViewModel()
    @State var showSelection = false
    
    private let filters = ["All", "Food", "Shop", "Transport", "Tourist", "Accommodation"]
    
    var body: some View {
        ZStack {
            List {
                ForEach(placesViewModel.places) { place in
                    NavigationLink(destination: MapView(place: place, location: placesViewModel.lastLocation!)) {
                        PlaceView(place: place)
                            .onAppear(perform: {
                                placesViewModel.loadMoreContent(currentItem: place)
                            })
                    }
                }
                if $placesViewModel.isLoading.wrappedValue {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .modifier(CenterModifier())
                        .padding(.all, 30)
                }
            }
            if $showSelection.wrappedValue {
                SelectionView(model: placesViewModel, filters: filters, showSelection: $showSelection)
            }
            if $placesViewModel.error.wrappedValue == PlacesError.authorization {
                ErrorView(title: Constants.Errors.authorizationErrorTitle, message: Constants.Errors.authorizationErrorText, error: $placesViewModel.error)
            }
            if $placesViewModel.error.wrappedValue == PlacesError.empty {
                ErrorView(title: Constants.Errors.emptyErrorTitle, message: Constants.Errors.emptyErrorText, error: $placesViewModel.error)
            }
            if $placesViewModel.error.wrappedValue == PlacesError.unknown {
                ErrorView(title: Constants.Errors.unknownErrorTitle, message: Constants.Errors.unknownErrorText, error: $placesViewModel.error)
            }
        }
        .navigationTitle(Constants.Titles.title)
        .navigationBarItems(leading: Button(action: {
                                                placesViewModel.invalidate()
                                                placesViewModel.loadContent()},
                                            label: {
                                                Image(systemName: "arrow.counterclockwise")
                                                        .foregroundColor(.white)
                                                        .imageScale(.medium)}),
                            trailing: Button(action: {
                                                self.showSelection = true},
                                             label: {
                                                Image(systemName: "ellipsis.circle")
                                                    .imageScale(.medium)
                                                    .foregroundColor(.white)
                            }))
        .onAppear(perform: {
            placesViewModel.loadContent()
        })
    }
}

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
                    Text(Constants.Titles.noAddress)
                        .font(.caption)
                }
                Text("Distance: \(place.distance.distanceInKm().description) km")
                    .font(.caption)
            }
        }
    }
}

struct ErrorView: View {
    let title: String
    let message: String
    
    @Binding var error: PlacesError
    
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 4.0) {
                HStack(alignment: .center, spacing: 4.0) {
                    Text(title)
                        .foregroundColor(.red)
                        .bold()
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    Spacer()
                    Button(action: {
                        self.error = .none
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                Text(message)
                    .font(.body)
                if error == .authorization {
                    Button(action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    }, label: {
                        Text(Constants.Titles.settings)
                    })
                }
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: self.getPopupMaxWidth(), minHeight: 0, maxHeight: 150)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct SelectionView: View {
    var model: PlacesViewModel
    var filters: Array<String>
    
    @Binding var showSelection: Bool
    
    var body: some View {
        ZStack {
            Color.white
            VStack {
                HStack {
                    Text(Constants.Titles.filter)
                        .bold()
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    Spacer()
                    Button(action: {
                        self.showSelection = false
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                }
                Spacer()
                List {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            self.model.invalidate(query: filter)
                            self.model.loadContent()
                            self.showSelection = false
                        }, label: {
                            Text(filter.capitalized)
                        })
                    }
                }
            }.padding()
        }
        .frame(minWidth: 0, maxWidth: self.getPopupMaxWidth(), minHeight: 0, maxHeight: 300)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
