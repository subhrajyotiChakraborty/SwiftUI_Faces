//
//  ContentView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var list = Faces()
    @State private var showEditPage = false
    
    func getFaceImage(faceObj: Face) -> Image {
        if faceObj.image != nil {
            let uiImage = faceObj.image!.getImage()
            guard let safeUIImage = uiImage else { return Image("defaultUser") }
            return Image(uiImage: safeUIImage)
        }
        return Image("defaultUser")
    }
    
    func removeItem(at offset: IndexSet) {
        list.faces.remove(atOffsets: offset)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func loadData() {
        let fileName = getDocumentsDirectory().appendingPathComponent("SavedFaces")
        do {
            let data = try Data(contentsOf: fileName)
            let faces = try JSONDecoder().decode([Face].self, from: data)
            list.faces = faces
        } catch {
            print("Unable to load saved data.")
        }
    }
    
    var body: some View {
        return NavigationView {
            List {
                ForEach(list.faces, id: \.id) { face in
                    NavigationLink(destination: EditView(faces: self.list, isEditMode: true, position: face.id)) {
                        self.getFaceImage(faceObj: face)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                            .padding(.trailing)
                        Text(face.name)
                    }
                }
                .onDelete(perform: removeItem)
            }
            .onAppear(perform: loadData)
            .navigationBarTitle("Faces")
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink(destination: EditView(faces: self.list, isEditMode: false), label: {
                Image(systemName: "plus")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
