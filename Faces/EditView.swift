//
//  EditView.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var jobTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                TextField("Job Title", text: $jobTitle)
            }
            .navigationBarTitle("Edit")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Done")
            }))
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
