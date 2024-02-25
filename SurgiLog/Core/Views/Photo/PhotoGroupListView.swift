//
//  PhotoGroupListView.swift
//  Test
//
//  Created by Tim Coder on 2/19/24.
//

import SwiftUI
import SwiftData

struct PhotoGroupCellView: View {
    @Bindable var photoGroup: PhotoGroup
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(photoGroup.photos ?? []) { photo in
                    VStack {
                        if let data = photo.imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(6)
                        }else{
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipped()
                        }
                        Text("\(photo.name)")
                    }
                }
            }
        }
    }
}
struct PhotoGroupListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var photoGroups: [PhotoGroup]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(photoGroups) { photoGroup in
                    PhotoGroupCellView(photoGroup: photoGroup)
                }
            }
            .navigationTitle("PhotoGroups")
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return PhotoGroupListView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Unable to create previewer")
    }
}
