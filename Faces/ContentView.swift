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
                Text(face.name)
            }
            .navigationBarTitle("Faces")
            .navigationBarItems(trailing: Button(action: {
                self.showEditPage = true
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showEditPage) {
                EditView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
