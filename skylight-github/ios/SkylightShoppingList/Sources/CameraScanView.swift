//
//  CameraScanView.swift
//  SkylightShoppingList
//
//  Camera interface for scanning fridge/pantry items
//

import SwiftUI
import PhotosUI

struct CameraScanView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var scanner = CameraScannerService.shared
    @State private var showingCamera = false
    @State private var showingPhotoPicker = false
    @State private var selectedImage: UIImage?
    @State private var scanResults: [String] = []
    @State private var showingResults = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
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
                        
                        Text("Take a photo of your fridge or pantry\nto automatically detect items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Preview Image
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                            .cornerRadius(16)
                            .shadow(radius: 8)
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
                        Button(action: { showingCamera = true }) {
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
                        
                        Button(action: { showingPhotoPicker = true }) {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Choose from Library")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(12)
                        }
                        
                        if selectedImage != nil {
                            Button(action: scanImage) {
                                HStack {
                                    if scanner.isScanning {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle())
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
