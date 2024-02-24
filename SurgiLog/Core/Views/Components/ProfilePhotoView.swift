//
//  ProfilePhotoView.swift
//  SurgiLog
//
//  Created by Tim Coder on 2/24/24.
//

import SwiftUI

struct ProfilePhotoView: View {
    let patient: Patient
    var body: some View {
        if let imageData = patient.imageData, let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage).resizable()
        } else {
            Image(systemName: "person").resizable()
        }
    }
}

#Preview {
    let preview = PatientPreview()
    
    return ProfilePhotoView(patient: preview.patients[0])
}
