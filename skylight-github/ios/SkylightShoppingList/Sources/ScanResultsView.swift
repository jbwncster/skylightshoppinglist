//
//  ScanResultsView.swift
//  SkylightShoppingList
//
//  Shows detected items and allows editing before adding to pantry
//

import SwiftUI

struct ScanResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @State var results: [String]
    let image: UIImage?
    
    @State private var editedItems: [PantryItem] = []
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Image Preview
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(12)
                        .padding()
                }
                
                // Header
                VStack(spacing: 8) {
                    Text("Detected \(results.count) Items")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Review and edit items before adding to pantry")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // Items List
                List {
                    ForEach(Array(editedItems.enumerated()), id: \.element.id) { index, item in
                        ItemEditRow(item: $editedItems[index])
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(InsetGroupedListStyle())
                
                // Add to Pantry Button
                Button(action: addToPantry) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Add \(editedItems.count) Items to Pantry")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Scan Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addNewItem) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .alert("Items Added", isPresented: $showingSuccess) {
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("\(editedItems.count) items have been added to your pantry")
            }
        }
        .onAppear {
            initializeItems()
        }
    }
    
    private func initializeItems() {
        editedItems = results.map { name in
            PantryItem(
                name: name,
                quantity: "1",
                category: CameraScannerService.shared.suggestCategory(for: name),
                expiryDate: nil,
                imageData: image?.jpegData(compressionQuality: 0.7),
                isInList: false
            )
        }
    }
    
    private func addNewItem() {
        let newItem = PantryItem(
            name: "New Item",
            quantity: "1",
            category: ItemCategory.other.rawValue
        )
        editedItems.append(newItem)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        editedItems.remove(atOffsets: offsets)
    }
    
    private func addToPantry() {
        appState.pantryItems.append(contentsOf: editedItems)
        savePantryItems()
        showingSuccess = true
    }
    
    private func savePantryItems() {
        if let encoded = try? JSONEncoder().encode(appState.pantryItems) {
            UserDefaults.standard.set(encoded, forKey: "pantryItems")
        }
    }
}

// MARK: - Item Edit Row
struct ItemEditRow: View {
    @Binding var item: PantryItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Item Name", text: $item.name)
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Qty", text: $item.quantity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Category")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Picker("Category", selection: $item.category) {
                        ForEach(ItemCategory.allCases, id: \.rawValue) { category in
                            Text("\(category.icon) \(category.rawValue)").tag(category.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
struct ScanResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ScanResultsView(results: ["Milk", "Eggs", "Bread", "Cheese"], image: nil)
            .environmentObject(AppState())
    }
}
