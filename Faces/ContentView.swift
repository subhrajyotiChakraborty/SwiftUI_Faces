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
    
    func updateList() {
        //        let updatedListData = list
        //        list = updatedListData
    }
    
    var body: some View {
        return NavigationView {
            List(list.faces, id: \.id) { face in
                NavigationLink(destination: EditView(faces: self.list, isEditMode: true, position: face.id)) {
                    Image("defaultUser")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .padding(.trailing)
                    Text(face.name)
                }
            }
            .navigationBarTitle("Faces")
            .onAppear(perform: updateList)
            .navigationBarItems(trailing: NavigationLink(destination: EditView(faces: self.list, isEditMode: false), label: {
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
