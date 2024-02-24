//
//  MainView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
//            Text("Surgeries")
//                .tabItem { Label("Surgeries", systemImage: "figure.run.square.stack") }
            NavigationStack {
                PatientListView()
                    .navigationTitle("Patients")
            }
            .tabItem { Label("Patients", systemImage: "person.circle") }
            Text("Photos")
                .tabItem { Label("Photos", systemImage: "photo")}
            NavigationStack {
                SettingsScreen()
                    .navigationTitle("Settings")
            }
            .tabItem { Label("Settings", systemImage: "gear")}
        }
    }
}

#Preview {
    let preview = HospitalPreview()
    
    return MainView().modelContainer(preview.container)
}
