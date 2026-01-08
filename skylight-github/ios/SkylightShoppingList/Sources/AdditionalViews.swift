//
//  AdditionalViews.swift
//  SkylightShoppingList
//
//  Helper views for the app
//

import SwiftUI

// MARK: - Add Item Manually View
struct AddItemManuallyView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    
    @State private var itemName = ""
    @State private var quantity = "1"
    @State private var category = ItemCategory.other.rawValue
    @State private var expiryDate = Date()
    @State private var hasExpiryDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details")) {
                    TextField("Item Name", text: $itemName)
                    TextField("Quantity", text: $quantity)
                }
                
                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
                        ForEach(ItemCategory.allCases, id: \.rawValue) { cat in
                            Text("\(cat.icon) \(cat.rawValue)").tag(cat.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Expiry Date")) {
                    Toggle("Has Expiry Date", isOn: $hasExpiryDate)
                    
                    if hasExpiryDate {
                        DatePicker("Expiry Date", selection: $expiryDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(itemName.isEmpty)
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = PantryItem(
            name: itemName,
            quantity: quantity,
            category: category,
            expiryDate: hasExpiryDate ? expiryDate : nil,
            imageData: nil,
            isInList: false
        )
        
        appState.pantryItems.append(newItem)
        
        if let encoded = try? JSONEncoder().encode(appState.pantryItems) {
            UserDefaults.standard.set(encoded, forKey: "pantryItems")
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Settings View
struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Connection")) {
                    HStack {
                        Text("Frame ID")
                        Spacer()
                        Text(appState.frameId)
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    
                    HStack {
                        Text("Auth Type")
                        Spacer()
                        Text(appState.authType.rawValue)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Status")
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                            Text("Connected")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Data")) {
                    HStack {
                        Text("Pantry Items")
                        Spacer()
                        Text("\(appState.pantryItems.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    Button("Clear Pantry") {
                        clearPantry()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("View on GitHub", destination: URL(string: "https://github.com/mightybandito/Skylight")!)
                    
                    Link("API Documentation", destination: URL(string: "https://mightybandito.github.io/Skylight/")!)
                }
                
                Section {
                    Button("Logout") {
                        showingLogoutAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Settings")
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Logout", role: .destructive) {
                    appState.logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
    
    private func clearPantry() {
        appState.pantryItems = []
        UserDefaults.standard.removeObject(forKey: "pantryItems")
    }
}

// MARK: - Previews
struct AdditionalViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AddItemManuallyView()
                .environmentObject(AppState())
            
            SettingsView()
                .environmentObject(AppState())
        }
    }
}
