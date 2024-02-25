//
//  HospitalListView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI
import SwiftData

struct HospitalListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var hospitals: [Hospital]
    
    var body: some View {
        List {
            ForEach(hospitals) { hospital in
                NavigationLink {
                    HospitalEditView(hospital: hospital) { hospital in
                        try? modelContext.save()
                    } delete: { hospital in
                        modelContext.delete(hospital)
                    }
                    .navigationTitle("Hospital Edit")
                } label: {
                    VStack(alignment: .leading) {
                        Text(hospital.name)
                        Text(hospital.longName).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
//    let preview = HospitalPreview()
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Hospital.self, configurations: config)
    let hospitals = [
        Hospital(name: "FUH", longName: "Famous University Hospital"),
        Hospital(name: "CMH", longName: "County Memorial Hospital"),
        Hospital(name: "VAMC", longName: "Veteran's Administration Medical Center")
    ]
    hospitals.forEach{container.mainContext.insert($0)}
    
    return NavigationStack {
        HospitalListView()
            .navigationTitle("Hospital List")
    }.modelContainer(container)
}
