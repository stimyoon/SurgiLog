//
//  PhotoEditView.swift
//  Test
//
//  Created by Tim Coder on 2/19/24.
//

import SwiftUI
import SwiftData
import PhotosUI

@Model
class Photo {
    var imageData: Data? = nil
    var name: String = ""
    var imageType: ImageType?
    var imageViewDirection: ImageViewDirection?
    var photoGroup: PhotoGroup?
    var patient: Patient?
    var surgery: Surgery?
    init(imageData: Data? = nil, name: String = "", photoGroup: PhotoGroup? = nil) {
        self.imageData = imageData
        self.name = name
    }
}

@Model
class PhotoGroup {
    var photos: [Photo]? = []
    var name: String = ""
    var surgery: Surgery?
    init(photos: [Photo]? = [], name: String = "", surgery: Surgery? = nil) {
        self.photos = photos
        self.name = name
        self.surgery = surgery
    }
}

@MainActor
struct Previewer {
    let container: ModelContainer
    let photos1: [Photo]
    let photos2: [Photo]
    let photoGroups: [PhotoGroup]
    let names1: [String] = [
        "Goh, Brian", "Garrard, Eli", "Hobson, Sandra"
    ]
    let names2: [String] = [
        "Michael, Keith", "Milby, Andrew"
    ]
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: PhotoGroup.self, configurations: config)
        
        self.photos1 = names1
            .compactMap{ UIImage(named: $0)?.pngData()}
            .map{ Photo(imageData: $0) }
        self.photos2 = names2
                .compactMap{ UIImage(named: $0)?.pngData()}
                .map{ Photo(imageData: $0) }
        
        self.photoGroups = [photos1, photos2].map({ photos in
            PhotoGroup(photos: photos, name: "")
        })
        self.photoGroups.forEach { container.mainContext.insert($0) }
    }
}

struct PhotoEditView: View {
    @Environment(\.modelContext) var modelContext
    @Query var imageTypes: [ImageType]
    
    @Bindable var photo: Photo
    @State private var photoItem: PhotosPickerItem?
    @State private var isShowingCameraSheet = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(6)
                    .padding(.leading)
            }
            LibraryPhotoPicker(photoItem: $photoItem, imageData: $photo.imageData).frame(width: 30, height: 30)
            showCameraSheetButton.frame(width: 30, height: 30).padding()
                .sheet(isPresented: $isShowingCameraSheet, content: {
                    Text("Camera View")
                })
            VStack {
                TextField("Photo Name", text: $photo.name)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text("Type")
                    Picker("Image Type", selection: $photo.imageType) {
                        Text("Not selected").tag(Optional<ImageType>.none)
                        if imageTypes.count > 0 {
                            Divider()
                            ForEach(imageTypes){ imageType in
                                Text(imageType.name).tag(imageType as ImageType?)
                            }
                        }
                    }
                }
            }
        }
        .toolbar {
            Button {
                
            } label: {
                Text("Save")
            }

        }
    }
    var showCameraSheetButton: some View {
        Button(action: {
            isShowingCameraSheet = true
        }, label: {
            Image(systemName: "camera").resizable().scaledToFit().frame(width: 50)
        })
    }
}

#Preview {
    
    do {
        let previewer = try Previewer()
        return NavigationStack {
            PhotoEditView(photo: previewer.photos1.first!)
                .navigationTitle("Photo Edit")
        }
    } catch {
        return Text("Unable to get previewer")
    }
}
