//
//  ContentView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let list = [
        Face(name: "One"),
        Face(name: "Two"),
        Face(name: "Three"),
        Face(name: "Four")
    ]
    @State private var showEditPage = false
    
    var body: some View {
        NavigationView {
            List(list) { face in
                NavigationLink(destination: EditView()) {
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
            .navigationBarItems(trailing: NavigationLink(destination: EditView(), label: {
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
