//
//  ImageTypeListView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/24/24.
//

import SwiftUI
import SwiftData

struct ImageTypeListView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \ImageType.createDate) var imageTypes: [ImageType]
    @State private var isShowingAlert = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.undoManager) var undoManager
    
    var body: some View {
        List {
            ForEach(imageTypes) { type in
                Group {
                    if isMandatory(type: type) {
                        Text(type.name)
                    } else {
                        @Bindable var type = type
                        TextField("Image Type", text: $type.name)
                    }
                }.deleteDisabled(isMandatory(type: type))
                    .swipeActions {
                        if !isMandatory(type: type) {
                            Button(role: .destructive, action: {
                                modelContext.delete(type)
                                isShowingAlert.toggle()
                            }, label: {
                                Text("Delete")
                            })
                            
                        }
                    }
            }
        }
        .toolbar {
            Button("Undo") {
                undoManager?.undo()
            }.disabled(undoManager?.canUndo == false)
            Button("Redo") {
                undoManager?.redo()
            }.disabled(undoManager?.canRedo == false)
            Button(action: {
                modelContext.insert(ImageType(name: "New Image Type"))
            }, label: {
                Image(systemName: "plus")
            })
        }
        .onAppear(perform: setupDataBase)
    }
    func isMandatory(type: ImageType)-> Bool {
        ImageType.names.contains(type.name)
    }
    func setupDataBase() {
//        ImageType.manatoryItems.forEach { mandatoryImageType in
//            if !imageTypes.contains(where: { type in
//                type.name == mandatoryImageType.name
//            }) {
//                modelContext.insert(mandatoryImageType)
//            }
//        }
        
    }
}

#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: ImageType.self, configurations: config)
//    container.mainContext.undoManager = UndoManager()
//    ImageType.names.forEach { container.mainContext.insert(ImageType(name: $0)) }
    
    return NavigationStack {
        ImageTypeListView()
            .navigationTitle("Image Types")
    }.modelContainer(for: ImageType.self, inMemory: true, isUndoEnabled: true)
}
