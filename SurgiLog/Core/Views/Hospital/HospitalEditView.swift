//
//  HospitalEditView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI
import SwiftData

@Model
class Hospital {
    var name = ""
    var longName = ""
    var surgeries: [Surgery]? = []
    init(name: String = "", longName: String = "", surgeries: [Surgery]? = []) {
        self.name = name
        self.longName = longName
        self.surgeries = surgeries
    }
}

struct HospitalEditView: View {
    @Bindable var hospital: Hospital
    var save: (Hospital)->()
    var delete: (Hospital)->()
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("Name", text: $hospital.name)
            TextField("Long Name", text: $hospital.longName)
            HStack {
                Spacer()
                Button(role: .destructive, action: {
                    delete(hospital)
                    dismiss()
                }, label: {
                    Text("Delete")
                })
                Spacer()
                Button(action: {
                    save(hospital)
                    dismiss()
                }, label: {
                    Text("Save")
                })
                Spacer()
            }
            .buttonStyle(.bordered)
        }
    }
}



@MainActor
struct HospitalPreview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer
    let hospitals = [
        Hospital(name: "FUH", longName: "Famous University Hospital"),
        Hospital(name: "CMH", longName: "County Memorial Hospital"),
        Hospital(name: "VAMC", longName: "Veteran's Administration Medical Center")
    ]
    init(){
        container = try! ModelContainer(for: Hospital.self, configurations: config)
        hospitals.forEach{container.mainContext.insert($0)}
    }
}
#Preview {
    let preview = HospitalPreview()
    return NavigationStack {
        HospitalEditView(hospital: preview.hospitals[0], save: {_ in}, delete: {_ in})
            .navigationTitle("Hospital Edit")
    }.modelContainer(preview.container)
}
