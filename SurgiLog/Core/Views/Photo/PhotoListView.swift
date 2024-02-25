//
//  PhotoListView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/25/24.
//

import SwiftUI
import SwiftData

struct PhotoListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var photos: [Photo]
    @State private var isShowingSheet = false
    
    var body: some View {
        List {
            ForEach(photos) { photo in
                NavigationLink {
                    PhotoEditView(photo: photo, save: update, delete: delete)
                } label: {
                    rowView(photo: photo)
                }
            }
        }
        .toolbar {
            Button(action: {
                isShowingSheet.toggle()
            }, label: {
                Image(systemName: "plus").font(.title2)
            })
        }
        .sheet(isPresented: $isShowingSheet, content: {
            NavigationStack {
                PhotoEditView(photo: Photo(), save: add, delete: delete)
                    .navigationTitle("Add Photo")
            }
        })
    }
    func rowView(photo: Photo) -> some View {
        HStack {
            ProfilePhotoView(imageData: photo.imageData).scaledToFit().frame(width: 50)
            VStack {
                if let type = photo.imageType {
                    Text(type.name)
                }
                if let view = photo.imageViewDirection {
                    Text(view.name)
                }
            }
        }
    }
    
    private func update(_ photo: Photo) {
        try? modelContext.save()
    }
    private func add(_ photo: Photo) {
        modelContext.insert(photo)
    }
    private func delete(_ photo: Photo) {
        modelContext.delete(photo)
    }
}

#Preview {
    PhotoListView()
        .modelContainer(for: Photo.self, inMemory: true)
}
