//
//  PlacesView.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import SwiftUI
import Combine

struct PlacesView: View {
    @StateObject var model = PlacesViewModel()
    
    var body: some View {
        List {
            ForEach(model.places) { place in
                PlaceView(place: place, location: model.getUserLocation())
                    .onAppear(perform: {
                        model.loadMoreContent(currentItem: place)
                    })
            }
            PlaceProgressView(isLoading: model.isLoading)
        }
        .navigationTitle("Places")
        .navigationBarItems(trailing: Button(
            action: { model.loadContent(invalidate: true) }) {
            Image(systemName: "arrow.counterclockwise")
                .foregroundColor(.white)
                .imageScale(.medium)
            })
        .onAppear(perform: {
            model.loadContent(invalidate: false)
        })
        .alert(isPresented: $model.authorizationDenied, content: {
            Alert(
                title: Text("Location permissions required"),
                message: Text("You have to give location permissions in order to use this application."),
                primaryButton: .default(Text("Settings"), action: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }),
                secondaryButton: .default(Text("Cancel"))
            )
        })
    }
}

struct PlaceProgressView: View {
    @State var isLoading: Bool = true
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .modifier(CenterModifier())
            .padding(.all, 30)
            .hidden(isLoading)
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

struct PlacesView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesView()
    }
}