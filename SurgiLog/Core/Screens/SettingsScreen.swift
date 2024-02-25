//
//  SettingsScreen.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI

struct SettingsScreen: View {
    var body: some View {
        List {
            NavigationLink {
                HospitalListView()
                    .navigationTitle("Hospitals")
            } label: {
                Text("Hospitals")
            }
            NavigationLink {
                ImageTypeListView()
            } label: {
                Text("Image Types")
            }

        }
    }
}

#Preview {
    let preview = HospitalPreview()
    
    return NavigationStack {
        SettingsScreen()
            .navigationTitle("Settings")
    }.modelContainer(preview.container)
}
