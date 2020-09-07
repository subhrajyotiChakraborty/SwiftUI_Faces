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
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
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
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage, content: {
            ImagePicker(image: self.$inputImage)
        })
            .navigationBarTitle("Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
