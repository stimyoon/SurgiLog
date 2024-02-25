//
//  LibraryPhotoPicker.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/25/24.
//

import SwiftUI
import PhotosUI

struct LibraryPhotoPicker: View {
    @Binding var photoItem: PhotosPickerItem?
    @Binding var imageData: Data?
    var body: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            Image(systemName: "photo.stack")
                .resizable()
                .scaledToFit()
        }
            .onChange(of: photoItem) {
                Task {
                    if let data = try? await
                        photoItem?.loadTransferable(type: Data.self) {
                        imageData = data
                    }
                }
            }
    }
}

#Preview {
    LibraryPhotoPicker(photoItem: .constant(Optional<PhotosPickerItem>.none), imageData: .constant(Optional<Data>.none))
}
