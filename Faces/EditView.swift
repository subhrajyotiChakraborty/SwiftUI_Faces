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
    var isEditMode: Bool
    var position: UUID?
    @State private var indexPosition: Int = 0
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func updateFormData() {
        if isEditMode {
            indexPosition = faces.faces.firstIndex(where: { $0.id == position! }) ?? 0
            name = faces.faces[indexPosition].name
            jobTitle = faces.faces[indexPosition].jobTitle
        }
    }
    
    func createFace() {
        var newFace = Face()
        newFace.name = name
        newFace.jobTitle = jobTitle
        
        faces.faces.insert(newFace, at: 0)
        
    }
    
    func updateListData() {
        faces.faces.remove(at: indexPosition)

        var newFace = Face()
        newFace.name = name
        newFace.jobTitle = jobTitle

        faces.faces.insert(newFace, at: indexPosition)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Job Title", text: $jobTitle)
            }
            
            Section {
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
                    self.showImagePicker = true
                }
            }
        }
        .onAppear(perform: updateFormData)
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$inputImage)
        })
            .navigationBarTitle(self.isEditMode ? "Details" : "Create", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if self.isEditMode {
                    self.updateListData()
                } else {
                    self.createFace()
                }
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
