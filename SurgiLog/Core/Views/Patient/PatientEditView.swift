//
//  PatientEditView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/23/24.
//

import SwiftUI
import SwiftData
import PhotosUI

@Model
class Procedure {
    var name = ""
    var surgeries: [Surgery]? = []
    init(name: String = "", surgeries: [Surgery]? = []) {
        self.name = name
        self.surgeries = surgeries
    }
}


@Model
class Surgery {
    var dos: Date = Date()
    var patient: Patient?
    @Relationship(inverse: \Hospital.surgeries) var hospital: Hospital?
    @Relationship(inverse: \Procedure.surgeries) var procedures: [Procedure]?
    @Relationship(inverse: \PhotoGroup.surgery) var photoGroups: [PhotoGroup]?
    init(dos: Date = Date(), patient: Patient? = nil, hospital: Hospital? = nil, procedures: [Procedure]? = [], photoGroups: [PhotoGroup]? = []) {
        self.dos = dos
        self.patient = patient
        self.hospital = hospital
        self.photoGroups = photoGroups
        self.procedures = procedures
    }
}

@Model
class Patient: Nameable {
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var dob = Date()
    var mrn = ""
    var imageData: Data?
    var surgeries: [Surgery]? = []
    init(firstName: String = "", middleName: String = "", lastName: String = "", dob: Date = Date(), mrn: String = "", imageData: Data? = nil, surgeries: [Surgery]? = []) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.dob = dob
        self.mrn = mrn
        self.imageData = imageData
        self.surgeries = surgeries
    }
}

struct PatientEditView: View {
    @Bindable var patient: Patient
    var save: (Patient)->()
    var delete: (Patient)->()
    
    @State private var isShowingCameraSheet = false
    @State private var photoItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            TextField("First Name", text: $patient.firstName)
            TextField("Middle Name", text: $patient.middleName)
            TextField("Last Name", text: $patient.lastName)
            TextField("MRN", text: $patient.mrn)
            DatePicker("DOB", selection: $patient.dob, displayedComponents: [.date])
            HStack {
                profilePhoto.frame(width: 70, height: 70).cornerRadius(6)
                Spacer()
                showCameraSheetButton.frame(width: 30, height: 30).padding()
                    .sheet(isPresented: $isShowingCameraSheet, content: {
                        Text("Camera View")
                    })
                PhotosPicker(selection: $photoItem, matching: .images) {
                    Image(systemName: "photo.stack").resizable().scaledToFit().frame(width: 30, height: 30)
                }
                    .onChange(of: photoItem) {
                        Task {
                            if let data = try? await
                                photoItem?.loadTransferable(type: Data.self) {
                                patient.imageData = data
                            }
                        }
                    }
            }.buttonStyle(.borderless)
            NavigationLink {
                Text("Surgery List")
            } label: {
                Text("Surgeries")
            }
            deleteButton
        }
        .toolbar {
            Button(action: {
                save(patient)
                dismiss()
            }, label: {
                Text("Save")
            })
        }
    }
    var profilePhoto: some View {
        if let imageData = patient.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage).resizable().scaledToFill()
        } else {
            Image(systemName: "person").resizable().scaledToFill()
        }
    }
    var showCameraSheetButton: some View {
        Button(action: {
            isShowingCameraSheet = true
        }, label: {
            Image(systemName: "camera").resizable().scaledToFit().frame(width: 50)
        })
    }
    var deleteButton: some View {
        Button(role: .destructive, action: {
            delete(patient)
            dismiss()
        }, label: {
            Text("Delete")
        })
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer = try! ModelContainer(for: Patient.self, configurations: config)
    let patients: [Patient] = [
        .init(firstName: "John", middleName: "Mid", lastName: "Smith", dob: Date().addingTimeInterval(-60*60*24*365*65), mrn: "34523142", imageData: nil),
        .init(firstName: "Mary", middleName: "Midwife", lastName: "Baker", dob: Date().addingTimeInterval(-60*60*24*365*65), mrn: "9872347", imageData: nil),
        .init(firstName: "Steve", middleName: "Korean", lastName: "Kim", dob: Date().addingTimeInterval(-60*60*24*365*65), mrn: "124050", imageData: nil),
    ]
    patients.forEach { container.mainContext.insert($0) }
    let data = UIImage(named: patients[0].lastAndFirstName)?.pngData()
    patients[0].imageData = data
    try? container.mainContext.save()
    
    return NavigationStack {
        PatientEditView(patient: patients[0], save: {_ in}, delete: {_ in})
            .navigationTitle("Patient Edit")
    }.modelContainer(container)
}
