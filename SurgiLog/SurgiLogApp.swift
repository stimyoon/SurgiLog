//
//  SurgiLogApp.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI
import SwiftData

@main
struct SurgiLogApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self, Hospital.self, Photo.self, PhotoGroup.self, Patient.self, Surgery.self, Procedure.self, ImageType.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
//            NavigationStack {
//                ImageTypeListView()
//                    .navigationTitle("Image Type List")
                MainView()
//                    .navigationTitle("Patients")
//            }
        }
        .modelContainer(for: [
            Item.self, Hospital.self, Photo.self, PhotoGroup.self, Patient.self, Surgery.self, Procedure.self, ImageType.self
        ], inMemory: true, isAutosaveEnabled: true, isUndoEnabled: true)
//        .modelContainer(sharedModelContainer, isUndoEnabled: true)
    }
    
}
