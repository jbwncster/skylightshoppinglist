//
//  ContentView.swift
//  SkylightShoppingList
//
//  Main app interface with tabs
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        if appState.isAuthenticated {
            TabView(selection: $selectedTab) {
                ShoppingListView()
                    .tabItem {
                        Label("Shopping", systemImage: "cart.fill")
                    }
                    .tag(0)
                
                CameraScanView()
                    .tabItem {
                        Label("Scan", systemImage: "camera.fill")
                    }
                    .tag(1)
                
                PantryView()
                    .tabItem {
                        Label("Pantry", systemImage: "square.grid.2x2.fill")
                    }
                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .accentColor(Color("AccentColor"))
        } else {
            LoginView()
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
