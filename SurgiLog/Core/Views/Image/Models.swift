//
//  Models.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/24/24.
//

import Foundation
import SwiftData

@Model
class ImageType {
    var name = ""
    var photos: [Photo]?
    var createDate = Date()
    
    init(name: String = "", photo: [Photo]? = nil) {
        self.name = name
        self.photos = photo
    }
    static let names: [String] = [
        "Photo", "X-ray", "CT", "MRI"
    ]
    static let manatoryItems: [ImageType] = [
        ImageType(name: "Photo"),
        ImageType(name: "X-ray"),
        ImageType(name: "CT"),
        ImageType(name: "MRI"),
    ]
}

@Model
class ImageViewDirection {
    var name = ""
    var photos: [Photo]?
    init(name: String = "", photos: [Photo]? = nil) {
        self.name = name
        self.photos = photos
    }
    static let names: [String] = [
        "AP", "PA", "Lat", "Axial", "Sagittal", "Coronal", "Flexion", "Extension"
    ]
}
