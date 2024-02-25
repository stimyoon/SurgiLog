////
////  PhotoEditorView.swift
////  SurgiLog
////
////  Created by Tim Coder on 2/25/24.
////
//
//import SwiftUI
//
//
//    import SwiftUI
//    import SwiftData
//    import PhotosUI
//    import SwiftUIImageViewer
//
//    enum ImageType: String, Identifiable, Codable, Hashable, CaseIterable {
//        var id : Self { self }
//        case photo, xray, ct, mri, fluoro
//    }
//    enum ImageViewType: String, Identifiable, Codable, Hashable, CaseIterable {
//        var id: Self { self }
//        case ap, lat, oblique, right, left, axial, sagittal, coronal
//    }
//
//    @Model
//    class Photo {
//        @Attribute(.externalStorage)
//        var imageData: Data? = nil
//        var createDate: Date = Date()
//        var photoGroup: PhotoGroup?
//        var photoDescription: String = ""
//        var imageType: ImageType?
//        var imageViewType: ImageViewType?
//        
//        init(imageData: Data? = nil, createDate: Date = Date(), photoGroup: PhotoGroup? = nil, photoDescription: String = "", imageType: ImageType? = nil, imageViewType: ImageViewType? = nil) {
//            self.imageData = imageData
//            self.createDate = createDate
//            self.photoGroup = photoGroup
//            self.photoDescription = photoDescription
//            self.imageType = imageType
//            self.imageViewType = imageViewType
//        }
//    }
//
//struct PhotoEditorView: View {
//        @Bindable var photo: Photo
//        var save: (Photo) -> ()
//        var delete: (Photo) -> ()
//        
//        @State private var photosPickerItem: PhotosPickerItem?
//        @State private var isShowingSheet = false
//        @State private var imageData: Data?
//        @State private var sourceType: SourceType?
//        @State private var isImagePresented = false
//        
//        
//        @Environment(\.dismiss) var dismiss
//        
//        var body: some View {
//            VStack {
//                if let data = imageData, let uiImage = UIImage(data: data) {
//                    let image = Image(uiImage: uiImage)
//                    image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity)
//                        .cornerRadius(4)
//                        .shadow(radius: 4)
//                        .onTapGesture {
//                            isImagePresented = true
//                        }
//                        .fullScreenCover(isPresented: $isImagePresented) {
//                            SwiftUIImageViewer(image: image)
//                                .overlay(alignment: .topTrailing) {
//                                    closeButton
//                                }
//                        }
//                }
//                List {
//                    TextField("Description", text: $photo.photoDescription)
//                        .onAppear {
//                            self.imageData = photo.imageData
//                        }
//                    PhotoTypePicker(photo: photo)
//                    PhotoViewPicker(photo: photo)
//                    
//                    HStack {
//                        Button {
//                            sourceType = .photoLibrary
//                        } label: {
//                            Label("Photos", systemImage: "photo.stack")
//                        }
//                        Spacer()
//                        Button(action: {
//                            sourceType = .camera
//                        }, label: {
//                            Label("Camera", systemImage: "camera")
//                        })
//                    }
//                    .buttonStyle(.bordered)
//                    
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            delete(photo)
//                            dismiss()
//                        }, label: {
//                            Text("Delete")
//                        })
//                        Spacer()
//                        Button(action: {
//                            save(photo)
//                            dismiss()
//                        }, label: {
//                            Text("Save")
//                        })
//                        Spacer()
//                    }
//                    .buttonStyle(.plain)
//                    .sheet(item: $sourceType) { sourceType in
//                        CameraView(sourceType: sourceType, imageData: $imageData, completion: {imageData in
//                            if let imageData {
//                                self.imageData = imageData
//                                photo.imageData = imageData
//                                save(photo)
//                            }
//                        })
//                    }
//                    .onChange(of: imageData) { oldValue, newValue in
//                        Task {
//                            withAnimation {
//                                if let imageData {
//                                    photo.imageData = imageData
//                                }
//                            }
//                        }
//                    }
//                }
//                .listStyle(.plain)
//            }
//        }
//        private var closeButton: some View {
//                Button {
//                    isImagePresented = false
//                } label: {
//                    Image(systemName: "xmark")
//                        .font(.headline)
//                }
//                .buttonStyle(.bordered)
//                .clipShape(Circle())
//                .padding()
//            }
//    }
//
//    #Preview {
//        NavigationStack {
//            PhotoEditView(photo: Photo(), save: {_ in}, delete: {_ in})
//        }
//    }
//
//#Preview {
//    PhotoEditorView()
//}
