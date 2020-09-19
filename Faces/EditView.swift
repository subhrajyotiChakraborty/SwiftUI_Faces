//
//  EditView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI
import MapKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var faces: Faces
    
    @State private var name = ""
    @State private var jobTitle = ""
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var indexPosition: Int = 0
    @State private var showFullImage = false
    @State private var showSheet = false
    
    let locationFetcher = LocationFetcher()
    var isEditMode: Bool
    var position: UUID?
    
    func getLocation() -> CLLocationCoordinate2D? {
        if let location = self.locationFetcher.lastKnownLocation {
            print("Your location is \(location)")
            return location
        } else {
            print("Your location is unknown")
            return nil
        }
    }
    
    func getFace() -> Face {
        let facePosition = faces.faces.firstIndex(where: { $0.id == position! }) ?? 0
        return faces.faces[facePosition]
    }
    
    func getSelectedFacesIndexPosition () -> Int {
        return faces.faces.firstIndex(where: { $0.id == position! }) ?? 0
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func updateFormData() {
        self.locationFetcher.start()
        
        if isEditMode {
            let selectedFace = getFace()
            indexPosition = getSelectedFacesIndexPosition()
            name = selectedFace.name
            jobTitle = selectedFace.jobTitle
            
            if selectedFace.image != nil {
                let faceImage = selectedFace.image!
                let uiImage = faceImage.getImage()
                guard let safeUIImage = uiImage else { return }
                image = Image(uiImage: safeUIImage)
                inputImage = safeUIImage
            }
        }
    }
    
    func createFace(at position: Int) {
        var newFace = Face()
        newFace.name = name
        newFace.jobTitle = jobTitle
        
        if image != nil {
            newFace.image = FaceImage(withImage: inputImage!)
        }
        
        if let currentLocation = getLocation() {
            print("lat =>", currentLocation.latitude)
            newFace.latitude = currentLocation.latitude
            print("lon =>", currentLocation.longitude)
            newFace.longitude = currentLocation.longitude
        }
        
        faces.faces.insert(newFace, at: position)
    }
    
    func updateFace() {
        createFace(at: indexPosition)
        faces.faces.remove(at: indexPosition + 1)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Job Title", text: $jobTitle)
            }
            
            Section {
                VStack {
                    ZStack {
                        if image != nil {
                            
                            image?
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image("defaultUser")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        Text("Tap to change the picture")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .onTapGesture {
                        self.showFullImage = false
                        self.showImagePicker = true
                        self.showSheet = true
                    }
                    
                    if isEditMode {
                        Button(action: {
                            self.showImagePicker = false
                            self.showFullImage = true
                            self.showSheet = true
                        }) {
                            Text("View Full Image")
                        }
                        .padding()
                        .border(Color.blue, width: 2)
                        .clipShape(Rectangle())
                    }
                }
            }
            
            if isEditMode {
                Section {
                    HStack(alignment: .center) {
                        NavigationLink(destination: UserMapView(latitude: self.getFace().latitude ?? 0, longitude: self.getFace().longitude ?? 0)) {
                            Image(systemName: "mappin.and.ellipse")
                            VStack(alignment: .leading) {
                                Text("Map Coordinates")
                                Text("lat: \(self.getFace().latitude ?? 0), long: \(self.getFace().longitude ?? 0)")
                            }
                            .padding(.leading)
                        }
                    }
                }
            }
        }
        .onAppear(perform: updateFormData)
        .sheet(isPresented: $showSheet, onDismiss: showImagePicker ? loadImage : nil, content: {
            if self.showImagePicker {
                ImagePicker(image: self.$inputImage)
            } else {
                if self.inputImage != nil {
                    Image(uiImage: self.inputImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Image("defaultUser")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        })
        .navigationBarTitle(self.isEditMode ? "Details" : "Create", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            if self.isEditMode {
                self.updateFace()
            } else {
                self.createFace(at: 0)
            }
            faces.save()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Done")
        }))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(faces: Faces(), isEditMode: false, position: UUID())
    }
}
