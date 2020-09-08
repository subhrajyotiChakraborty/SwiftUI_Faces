//
//  EditView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var jobTitle = ""
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @ObservedObject var faces: Faces
    @State private var indexPosition: Int = 0
    @State private var showFullImage = false
    @State private var showSheet = false
    var isEditMode: Bool
    var position: UUID?
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveData() {
        do {
            let fileName = getDocumentsDirectory().appendingPathComponent("SavedFaces")
            let data = try JSONEncoder().encode(self.faces.faces)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch  {
            print("Unable to save data.")
        }
    }
    
    func updateFormData() {
        if isEditMode {
            indexPosition = faces.faces.firstIndex(where: { $0.id == position! }) ?? 0
            name = faces.faces[indexPosition].name
            jobTitle = faces.faces[indexPosition].jobTitle
            if faces.faces[indexPosition].image != nil {
                let faceImage = faces.faces[indexPosition].image!
                let uiImage = faceImage.getImage()
                guard let safeUIImage = uiImage else { return }
                image = Image(uiImage: safeUIImage)
                inputImage = safeUIImage
            }
        }
    }
    
    func createFace() {
        var newFace = Face()
        newFace.name = name
        newFace.jobTitle = jobTitle
        if image != nil {
            newFace.image = FaceImage(withImage: inputImage!)
        }
        faces.faces.insert(newFace, at: 0)
        
    }
    
    func updateListData() {
        faces.faces.remove(at: indexPosition)
        
        var newFace = Face()
        newFace.name = name
        newFace.jobTitle = jobTitle
        if image != nil {
            guard let inputImage = inputImage else { return }
            let faceImage = FaceImage(withImage: inputImage)
            newFace.image = faceImage
        }
        faces.faces.insert(newFace, at: indexPosition)
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
                    
                    Button(action: {
                        self.showImagePicker = false
                        self.showFullImage = true
                        self.showSheet = true
                    }) {
                        Text("View Full Image")
                    }
                    .padding()
                    .border(Color.blue, width: 5)
                    .clipShape(Rectangle())
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
                    self.updateListData()
                } else {
                    self.createFace()
                }
                self.saveData()
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
