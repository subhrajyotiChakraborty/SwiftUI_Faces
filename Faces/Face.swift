//
//  Face.swift
//  Faces
//
//  Created by Subhrajyoti Chakraborty on 05/09/20.
//  Copyright © 2020 Subhrajyoti Chakraborty. All rights reserved.
//

import SwiftUI


struct Face: Identifiable, Codable {
    let id = UUID()
    var name = ""
    var jobTitle = ""
}


class Faces: ObservableObject {
    @Published var faces: [Face] = []
}
