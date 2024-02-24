//
//  PatientListView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/24/24.
//

import SwiftUI
import SwiftData

struct PatientListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var patients: [Patient]
    @State private var isShowingSheet = false
    
    var body: some View {
        List {
            ForEach(patients) { patient in
                NavigationLink {
                    PatientEditView(patient: patient) { _ in
                        try? modelContext.save()
                    } delete: {
                        modelContext.delete($0)
                    }
                } label: {
                    RowView(patient: patient)
                }
                .listRowInsets(.init(top: 10, leading: 10, bottom: 10, trailing: 20))
            }
        }
        .toolbar {
            Button(action: {
                isShowingSheet = true
            }, label: {
                Image(systemName: "plus").font(.title2)
            })
        }
        .sheet(isPresented: $isShowingSheet, content: {
            NavigationStack {
                PatientEditView(patient: Patient(), save: { modelContext.insert($0)}, delete: { modelContext.delete($0)})
                    .navigationTitle("Patient Add")
            }
        })
    }
}
extension PatientListView {
    struct RowView: View {
        let patient: Patient
        var body: some View {
            HStack {
                ProfilePhotoView(patient: patient).scaledToFit().frame(width: 40, height: 40).cornerRadius(3.0)
                Text(patient.formalName)
            }
        }
    }
}

#Preview {
    let preview = PatientPreview()
    
    return NavigationStack {
        PatientListView()
            .navigationTitle("Patients")
    }.modelContainer(preview.container)
}
