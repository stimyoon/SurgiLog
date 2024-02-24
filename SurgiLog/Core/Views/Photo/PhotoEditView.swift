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
    var photoGroup: PhotoGroup?
    var patient: Patient?
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
    var photo: Photo
    var body: some View {
        HStack {
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
            Text("\(photo.name)")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return PhotoEditView(photo: previewer.photos1.first!)
    } catch {
        return Text("Unable to get previewer")
    }
}
