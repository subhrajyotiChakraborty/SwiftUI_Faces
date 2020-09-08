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
    var image: FaceImage?
}

struct FaceImage: Codable{
    let imageData: Data?
    
    init(withImage image: UIImage) {
        self.imageData = image.pngData()
    }

    func getImage() -> UIImage? {
        guard let imageData = self.imageData else {
            return nil
        }
        let image = UIImage(data: imageData)
        
        return image
    }
}


class Faces: ObservableObject {
    @Published var faces: [Face] = []
}
