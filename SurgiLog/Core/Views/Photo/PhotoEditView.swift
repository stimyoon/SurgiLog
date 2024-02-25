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
    private(set) var imageData: Data? = nil
    var photoDescription: String = ""
    var imageType: ImageType?
    var imageViewDirection: ImageViewDirection?
    var photoGroup: PhotoGroup?
    var patient: Patient?
    var surgery: Surgery?
    var createDate: Date = Date()
    var modifiedDate: Date = Date()
    
    func setImageData(_ data: Data?) {
        modifiedDate = Date()
        imageData = data
    }
    init(imageData: Data? = nil, photoDescription: String = "", photoGroup: PhotoGroup? = nil) {
        self.imageData = imageData
        self.photoDescription = photoDescription
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
    var save: (Photo)->()
    var delete: (Photo)->()
    
    @State private var imageData: Data?
    @State private var photoItem: PhotosPickerItem?
    @State private var isShowingCameraSheet = false
    @State private var isImagePresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
                let image = Image(uiImage: uiImage)
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(6)
                    .padding()
                    .onTapGesture {
                        isImagePresented = true
                    }
                    .fullScreenCover(isPresented: $isImagePresented) {
                        SwiftUIImageViewer(image: image)
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    isImagePresented.toggle()
                                } label: {
                                    Text("Done")
                                }
                            }
                    }
            }
                
            
            LibraryPhotoPicker(photoItem: $photoItem, imageData: $imageData).frame(width: 30, height: 30)
                .onChange(of: imageData) { oldValue, newValue in
                    photo.setImageData(imageData)
                }
            showCameraSheetButton.frame(width: 30, height: 30).padding()
                .sheet(isPresented: $isShowingCameraSheet, content: {
                    CameraView { data in
                        photo.setImageData(data)
                    }
                })
            
            
            TextField("Photo Name", text: $photo.photoDescription)
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
            Button(role: .destructive) {
                delete(photo)
            } label: {
                Text("Delete")
            }

        }
        .toolbar {
            Button {
                save(photo)
                dismiss()
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
            PhotoEditView(photo: previewer.photos1.first!, save: {_ in}, delete: {_ in})
                .navigationTitle("Photo Edit")
        }
    } catch {
        return Text("Unable to get previewer")
    }
}
