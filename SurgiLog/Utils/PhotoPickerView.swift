//
//  PhotoPickerView.swift
//  CasePhotos
//
//  Created by Tim Coder on 2/17/24.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var photoItem: PhotosPickerItem?
    @State private var image: Image?
    @Binding var imageData: Data?
    
    var body: some View {
        VStack {
            PhotosPicker("Select Photo", selection: $photoItem, matching: .images)
            
            image?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            if let imageData {
                Image(uiImage: UIImage(data: imageData)!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
        }
        .onChange(of: photoItem) {
            Task {
                if let loaded = try? await photoItem?.loadTransferable(type: Image.self) {
                    image = loaded
                    
                } else {
                    print("Failed")
                }
                if let data = try? await
                    photoItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}

struct PreviewPhotoPickerView: View {
    @State private var imageData: Data?
    
    var body: some View {
        PhotoPickerView(imageData: $imageData)
    }
}
#Preview {
  
    PreviewPhotoPickerView()
}
