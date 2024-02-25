//
//  PhotoGroupEditView.swift
//  Test
//
//  Created by Tim Coder on 2/19/24.
//

import SwiftUI

struct PhotoGroupEditView: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var photoGroup: PhotoGroup
    @State private var isShowingSheet = false
    @State private var name = ""
    var body: some View {
        PhotoGroupCellView(photoGroup: photoGroup)
            .toolbar {
                Button(action: {
                    isShowingSheet = true
                }, label: {
                    Text("Add Photo")
                })
                .buttonStyle(.bordered)
            }
            .sheet(isPresented: $isShowingSheet, content: {
                TextField("name", text: $name)
                Button(action: {
                    
                    if let uiImage = UIImage(named: name), let data = uiImage.pngData() {
                        let photo = Photo(imageData: data, photoDescription: name, photoGroup: photoGroup)
                        modelContext.insert(photo)
                        photoGroup.photos?.append(photo)
//                        try? modelContext.save()
                    }
                }, label: {
                    Text("Add")
                })
            })
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        return NavigationStack {
            PhotoGroupEditView(photoGroup: previewer.photoGroups.first!)
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Unable to make preview")
    }
}
