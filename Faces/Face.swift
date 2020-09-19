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
    var latitude: Double?
    var longitude: Double?
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
    @Published var faces: [Face]
    static let saveKey = "SavedFaces"
    
    init() {
        do {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let filePath = paths[0].appendingPathComponent(Self.saveKey)
            let data = try Data(contentsOf: filePath)
            let decodeData = try JSONDecoder().decode([Face].self, from: data)
            self.faces = decodeData
            return
        } catch {
            print("Unable to load data \(error.localizedDescription)")
        }
        
        self.faces = []
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let filePath = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        do {
            let data = try JSONEncoder().encode(faces)
            try data.write(to: filePath, options: [.atomicWrite, .completeFileProtection])
        } catch  {
            print("Unable to save data \(error.localizedDescription)")
        }
    }
}
