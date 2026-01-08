//
//  PantryView.swift
//  SkylightShoppingList
//
//  View and manage pantry items detected from camera scans
//

import SwiftUI

struct PantryView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedCategory: ItemCategory?
    @State private var showingAddSheet = false
    @State private var sortBy: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case category = "Category"
        case date = "Date Added"
    }
    
    var filteredItems: [PantryItem] {
        var items = appState.pantryItems
        
        // Filter by search
        if !searchText.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Filter by category
        if let category = selectedCategory {
            items = items.filter { $0.category == category.rawValue }
        }
        
        // Sort
        switch sortBy {
        case .name:
            items.sort { $0.name < $1.name }
        case .category:
            items.sort { $0.category < $1.category }
        case .date:
            items.sort { item1, item2 in
                // Most recent first
                return true
            }
        }
        
        return items
    }
    
    var groupedItems: [(category: String, items: [PantryItem])] {
        let grouped = Dictionary(grouping: filteredItems) { $0.category }
        return grouped.map { (category: $0.key, items: $0.value) }
            .sorted { $0.category < $1.category }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search pantry items", text: $searchText)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterChip(
                            title: "All",
                            icon: "square.grid.2x2",
                            isSelected: selectedCategory == nil
                        ) {
                            selectedCategory = nil
                        }
                        
                        ForEach(ItemCategory.allCases, id: \.self) { category in
                            CategoryFilterChip(
                                title: category.rawValue,
                                icon: category.icon,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Items List
                if filteredItems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tray")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No items in pantry")
                            .font(.headline)
                        
                        Text("Scan your fridge or add items manually")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    List {
                        ForEach(groupedItems, id: \.category) { group in
                            Section(header: Text(group.category).font(.headline)) {
                                ForEach(group.items) { item in
                                    PantryItemRow(item: item)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                deleteItem(item)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                toggleInList(item)
                                            } label: {
                                                Label(
                                                    item.isInList ? "Remove from List" : "Add to List",
                                                    systemImage: item.isInList ? "cart.fill.badge.minus" : "cart.fill.badge.plus"
                                                )
                                            }
                                            .tint(.green)
                                        }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("My Pantry")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Picker("Sort By", selection: $sortBy) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddItemManuallyView()
                    .environmentObject(appState)
            }
        }
        .onAppear {
            loadPantryItems()
        }
    }
    
    private func loadPantryItems() {
        if let data = UserDefaults.standard.data(forKey: "pantryItems"),
           let items = try? JSONDecoder().decode([PantryItem].self, from: data) {
            appState.pantryItems = items
        }
    }
    
    private func deleteItem(_ item: PantryItem) {
        appState.pantryItems.removeAll { $0.id == item.id }
        savePantryItems()
    }
    
    private func toggleInList(_ item: PantryItem) {
        if let index = appState.pantryItems.firstIndex(where: { $0.id == item.id }) {
            appState.pantryItems[index].isInList.toggle()
            savePantryItems()
        }
    }
    
    private func savePantryItems() {
        if let encoded = try? JSONEncoder().encode(appState.pantryItems) {
            UserDefaults.standard.set(encoded, forKey: "pantryItems")
        }
    }
}

// MARK: - Category Filter Chip
struct CategoryFilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if icon.count == 1 {
                    Text(icon)
                } else {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color("AccentColor") : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

// MARK: - Pantry Item Row
struct PantryItemRow: View {
    let item: PantryItem
    
    var body: some View {
        HStack(spacing: 12) {
            // Image or Icon
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .font(.title2)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            // Item Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                
                HStack {
                    Text(item.quantity)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if item.isInList {
                        Image(systemName: "cart.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            // Category Icon
            if let category = ItemCategory(rawValue: item.category) {
                Text(category.icon)
                    .font(.title2)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
            .environmentObject(AppState())
    }
}
