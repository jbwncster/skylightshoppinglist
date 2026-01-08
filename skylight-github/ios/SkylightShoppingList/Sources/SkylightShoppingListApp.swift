//
//  SkylightShoppingListApp.swift
//  SkylightShoppingList
//
//  iOS app for managing Skylight shopping lists with camera scanning
//

import SwiftUI

@main
struct SkylightShoppingListApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

// MARK: - App State
class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var frameId: String = ""
    @Published var authToken: String = ""
    @Published var authType: AuthType = .bearer
    @Published var currentList: ShoppingList?
    @Published var pantryItems: [PantryItem] = []
    
    enum AuthType: String, CaseIterable {
        case bearer = "Bearer"
        case basic = "Basic"
    }
    
    init() {
        loadCredentials()
    }
    
    func loadCredentials() {
        if let frameId = UserDefaults.standard.string(forKey: "frameId"),
           let authToken = UserDefaults.standard.string(forKey: "authToken"),
           let authTypeRaw = UserDefaults.standard.string(forKey: "authType"),
           let authType = AuthType(rawValue: authTypeRaw) {
            self.frameId = frameId
            self.authToken = authToken
            self.authType = authType
            self.isAuthenticated = !frameId.isEmpty && !authToken.isEmpty
        }
    }
    
    func saveCredentials() {
        UserDefaults.standard.set(frameId, forKey: "frameId")
        UserDefaults.standard.set(authToken, forKey: "authToken")
        UserDefaults.standard.set(authType.rawValue, forKey: "authType")
        self.isAuthenticated = !frameId.isEmpty && !authToken.isEmpty
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "frameId")
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "authType")
        self.isAuthenticated = false
        self.frameId = ""
        self.authToken = ""
    }
}
