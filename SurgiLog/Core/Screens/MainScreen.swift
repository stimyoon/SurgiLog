//
//  MainView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @Query var imageTypes: [ImageType]
    
    var body: some View {
        TabView {
//            Text("Surgeries")
//                .tabItem { Label("Surgeries", systemImage: "figure.run.square.stack") }
            NavigationStack {
                PatientListView()
                    .navigationTitle("Patients")
            }
            .tabItem { Label("Patients", systemImage: "person.circle") }
            
            NavigationStack {
                PhotoListView()
                    .navigationTitle("Photos")
            }
            .tabItem { Label("Photos", systemImage: "photo")}
            
            NavigationStack {
                SettingsScreen()
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gear")}
        }
        .task {
            setupDatabase()
        }
    }
    func setupDatabase() {
        ImageType.manatoryItems.forEach { mandatoryImageType in
            if !imageTypes.contains(where: { type in
                type.name == mandatoryImageType.name
            }) {
                modelContext.insert(mandatoryImageType)
            }
        }
        
    }
}

#Preview {
    let preview = HospitalPreview()
    
    return MainView().modelContainer(preview.container)
}
