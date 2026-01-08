//
//  CameraScanView.swift (UPDATED with Photo Upload)
//  SkylightShoppingList
//
//  Camera interface for scanning fridge/pantry items with manual photo upload
//

import SwiftUI
import PhotosUI

struct CameraScanView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var scanner = CameraScannerService.shared
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false
    @State private var showingFilePicker = false
    @State private var selectedImage: UIImage?
    @State private var scanResults: [String] = []
    @State private var showingResults = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var photoSource: PhotoSource = .camera
    
    enum PhotoSource {
        case camera, library, files
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(Color("AccentColor"))
                        
                        Text("Scan Your Pantry")
                            .font(.custom("DMSerifDisplay-Regular", size: 28))
                        
                        Text("Take a photo or upload an existing image\nto automatically detect items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Preview Image
                    if let image = selectedImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .cornerRadius(16)
                                .shadow(radius: 8)
                            
                            // Remove button
                            Button(action: { 
                                selectedImage = nil
                                scanResults = []
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                            }
                            .padding(8)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Scanning Progress
                    if scanner.isScanning {
                        VStack(spacing: 12) {
                            ProgressView(value: scanner.scanProgress)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color("AccentColor")))
                            
                            Text("Analyzing image...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        // Camera Button
                        Button(action: { 
                            photoSource = .camera
                            showingCamera = true 
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Take Photo")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Photo Library Button
                        Button(action: { 
                            photoSource = .library
                            showingPhotoPicker = true 
                        }) {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Choose from Photos")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // File Picker Button (NEW)
                        Button(action: { 
                            photoSource = .files
                            showingFilePicker = true 
                        }) {
                            HStack {
                                Image(systemName: "folder.fill")
                                Text("Upload from Files")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        // Scan Button
                        if selectedImage != nil {
                            Button(action: scanImage) {
                                HStack {
                                    if scanner.isScanning {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "wand.and.rays")
                                        Text("Scan for Items")
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            .disabled(scanner.isScanning)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Tips Card
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Scanning Tips", systemImage: "lightbulb.fill")
                            .font(.headline)
                            .foregroundColor(Color("AccentColor"))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TipRow(icon: "checkmark.circle", text: "Ensure good lighting")
                            TipRow(icon: "checkmark.circle", text: "Keep camera steady")
                            TipRow(icon: "checkmark.circle", text: "Capture product labels clearly")
                            TipRow(icon: "checkmark.circle", text: "Show multiple items at once")
                            TipRow(icon: "checkmark.circle", text: "Can upload existing photos")
                        }
                    }
                    .padding()
                    .background(Color("AccentColor").opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Camera Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingCamera) {
                CameraPickerView(image: $selectedImage)
            }
            .sheet(isPresented: $showingPhotoPicker) {
                PhotoPickerView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingFilePicker) {
                DocumentPickerView(selectedImage: $selectedImage)
            }
            .sheet(isPresented: $showingResults) {
                ScanResultsView(results: scanResults, image: selectedImage)
                    .environmentObject(appState)
            }
            .alert("Scan Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func scanImage() {
        guard let image = selectedImage else { return }
        
        Task {
            do {
                let result = try await scanner.scanImage(image)
                
                await MainActor.run {
                    scanResults = result.detectedItems
                    if scanResults.isEmpty {
                        errorMessage = "No items detected. Try a clearer photo with visible product labels."
                        showingError = true
                    } else {
                        showingResults = true
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                }
            }
        }
    }
}

// MARK: - Document Picker (NEW)
struct DocumentPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [.image, .jpeg, .png]
        )
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            // Load image from URL
            if let imageData = try? Data(contentsOf: url),
               let image = UIImage(data: imageData) {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Tip Row Component
struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .font(.caption)
            Text(text)
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview
struct CameraScanView_Previews: PreviewProvider {
    static var previews: some View {
        CameraScanView()
            .environmentObject(AppState())
    }
}
