//
//  LoginView.swift
//  SkylightShoppingList
//
//  Authentication screen for Skylight credentials
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var frameId = ""
    @State private var authToken = ""
    @State private var authType: AppState.AuthType = .bearer
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isConnecting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "cart.fill.badge.plus")
                            .font(.system(size: 80))
                            .foregroundColor(Color("AccentColor"))
                            .padding(.top, 40)
                        
                        Text("Skylight Shopping List")
                            .font(.custom("DMSerifDisplay-Regular", size: 32))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Scan your fridge & sync with Skylight")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 20)
                    
                    // Instructions Card
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Setup Instructions", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundColor(Color("AccentColor"))
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Use Proxyman or Charles Proxy")
                            Text("2. Capture Skylight app traffic")
                            Text("3. Copy Authorization header")
                            Text("4. Find your Frame ID in API calls")
                            Text("5. Enter credentials below")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        
                        Link("View Auth Guide →", destination: URL(string: "https://github.com/mightybandito/Skylight/blob/main/docs/auth.md")!)
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color("AccentColor").opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Input Fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Frame ID")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter your Frame ID", text: $frameId)
                                .textFieldStyle(RoundedTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Auth Type")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            Picker("Auth Type", selection: $authType) {
                                ForEach(AppState.AuthType.allCases, id: \.self) { type in
                                    Text(type.rawValue).tag(type)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Token")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                            
                            SecureField("Enter your auth token", text: $authToken)
                                .textFieldStyle(RoundedTextFieldStyle())
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Connect Button
                    Button(action: connect) {
                        HStack {
                            if isConnecting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                Text("Connect to Skylight")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("AccentColor"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color("AccentColor").opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .disabled(frameId.isEmpty || authToken.isEmpty || isConnecting)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .alert("Connection Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func connect() {
        isConnecting = true
        
        Task {
            do {
                // Test connection by fetching lists
                let lists = try await SkylightAPIService.shared.fetchLists(
                    frameId: frameId,
                    authToken: authToken,
                    authType: authType.rawValue
                )
                
                await MainActor.run {
                    appState.frameId = frameId
                    appState.authToken = authToken
                    appState.authType = authType
                    appState.saveCredentials()
                    isConnecting = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isConnecting = false
                }
            }
        }
    }
}

// MARK: - Custom TextField Style
struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppState())
    }
}
