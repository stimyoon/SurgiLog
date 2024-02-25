//
//  ProfilePhotoView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/24/24.
//

import SwiftUI
import SwiftData

struct ProfilePhotoView: View {
    let imageData: Data?
    var body: some View {
        if let imageData = imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage).resizable()
        } else {
            Image(systemName: "person").resizable()
        }
    }
}

#Preview {
    let data = UIImage(named: "Smith, John")?.pngData()
    
    return ProfilePhotoView(imageData: data)
    
}
