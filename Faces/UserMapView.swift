//
//  UserMapView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 10/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI
import MapKit

struct UserMapView: View {
    @State private var locations = [MKPointAnnotation]()
    @Environment (\.presentationMode) var presentationMode
    
    var latitude: Double?
    var longitude: Double?
    
    
    var body: some View {
        ZStack {
            MapView(annotations: self.locations, latitude: latitude!, longitude: longitude!)
        }
        .onAppear(perform: {
            print(self.latitude!)
            let place = MKPointAnnotation()
            place.coordinate = CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
            place.title = "Image Location"
            locations.append(place)
        })
        .navigationBarTitle("Map View", displayMode: .inline)
    }
}

struct UserMapView_Previews: PreviewProvider {
    static var previews: some View {
        UserMapView()
    }
}
