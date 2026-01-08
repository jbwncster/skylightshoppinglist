//
//  ShoppingListView.swift
//  SkylightShoppingList
//
//  Main shopping list view with Skylight API integration
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var appState: AppState
    @State private var lists: [ShoppingList] = []
    @State private var selectedList: ShoppingList?
    @State private var listItems: [ListItem] = []
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var newItemName = ""
    @State private var showingShareSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // List Selector
                if !lists.isEmpty {
                    Picker("Select List", selection: $selectedList) {
                        ForEach(lists) { list in
                            Text("\(list.attributes.label) \(list.attributes.kind == "shopping" ? "🛒" : "")").tag(list as ShoppingList?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .onChange(of: selectedList) { newValue in
                        if let list = newValue {
                            loadListItems(list)
                        }
                    }
                }
                
                // Add Item From Pantry
                if !appState.pantryItems.filter({ !$0.isInList }).isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(appState.pantryItems.filter { !$0.isInList }.prefix(5)) { item in
                                Button(action: { addPantryItemToList(item) }) {
                                    HStack(spacing: 6) {
                                        Text(item.name)
                                            .font(.caption)
                                        Image(systemName: "plus.circle.fill")
                                            .font(.caption)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color("AccentColor").opacity(0.1))
                                    .foregroundColor(Color("AccentColor"))
                                    .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                }
                
                // Manual Add Item
                HStack {
                    TextField("Add item to list", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: addNewItem) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .disabled(newItemName.isEmpty)
                }
                .padding()
                
                // Items List
                if isLoading {
                    Spacer()
                    ProgressView("Loading...")
                    Spacer()
                } else if listItems.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("Your shopping list is empty")
                            .font(.headline)
                        
                        Text("Add items from your pantry or create new ones")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(groupedItems, id: \.section) { group in
                            Section(header: Text(group.section).font(.headline)) {
                                ForEach(group.items.indices, id: \.self) { index in
                                    ShoppingListItemRow(item: $listItems[getItemIndex(group.items[index])])
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Summary Bar
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(activeItemCount) items to buy")
                                .font(.headline)
                            Text("\(completedItemCount) completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showingShareSheet = true }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color("AccentColor"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadLists) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(text: generateShareText())
            }
        }
        .onAppear {
            loadLists()
        }
    }
    
    // MARK: - Data Helpers
    
    var groupedItems: [(section: String, items: [ListItem])] {
        let grouped = Dictionary(grouping: listItems) { $0.attributes.section ?? "Uncategorized" }
        return grouped.map { (section: $0.key, items: $0.value) }
            .sorted { $0.section < $1.section }
    }
    
    var activeItemCount: Int {
        listItems.filter { !$0.isCompleted }.count
    }
    
    var completedItemCount: Int {
        listItems.filter { $0.isCompleted }.count
    }
    
    func getItemIndex(_ item: ListItem) -> Int {
        listItems.firstIndex(where: { $0.id == item.id }) ?? 0
    }
    
    // MARK: - API Methods
    
    private func loadLists() {
        isLoading = true
        
        Task {
            do {
                let fetchedLists = try await SkylightAPIService.shared.fetchLists(
                    frameId: appState.frameId,
                    authToken: appState.authToken,
                    authType: appState.authType.rawValue
                )
                
                await MainActor.run {
                    lists = fetchedLists
                    if let shoppingList = lists.first(where: { $0.attributes.kind == "shopping" }) {
                        selectedList = shoppingList
                        loadListItems(shoppingList)
                    } else if let firstList = lists.first {
                        selectedList = firstList
                        loadListItems(firstList)
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func loadListItems(_ list: ShoppingList) {
        isLoading = true
        
        Task {
            do {
                let (_, items) = try await SkylightAPIService.shared.fetchListDetail(
                    frameId: appState.frameId,
                    listId: list.id,
                    authToken: appState.authToken,
                    authType: appState.authType.rawValue
                )
                
                await MainActor.run {
                    listItems = items.sorted { ($0.attributes.position ?? 0) < ($1.attributes.position ?? 0) }
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
    
    private func addNewItem() {
        let newItem = ListItem(
            type: "list_item",
            id: "temp_\(UUID().uuidString)",
            attributes: ListItem.Attributes(
                label: newItemName,
                status: "pending",
                section: nil,
                position: listItems.count,
                createdAt: nil
            )
        )
        
        listItems.append(newItem)
        newItemName = ""
    }
    
    private func addPantryItemToList(_ pantryItem: PantryItem) {
        // Mark as in list
        if let index = appState.pantryItems.firstIndex(where: { $0.id == pantryItem.id }) {
            appState.pantryItems[index].isInList = true
        }
        
        let newItem = ListItem(
            type: "list_item",
            id: "temp_\(UUID().uuidString)",
            attributes: ListItem.Attributes(
                label: pantryItem.name,
                status: "pending",
                section: pantryItem.category,
                position: listItems.count,
                createdAt: nil
            )
        )
        
        listItems.append(newItem)
    }
    
    private func generateShareText() -> String {
        guard let list = selectedList else { return "" }
        
        var text = "\(list.attributes.label)\n\n"
        
        let pending = listItems.filter { !$0.isCompleted }
        let completed = listItems.filter { $0.isCompleted }
        
        text += "TO BUY (\(pending.count)):\n"
        pending.forEach { text += "☐ \($0.attributes.label)\n" }
        
        if !completed.isEmpty {
            text += "\nCOMPLETED (\(completed.count)):\n"
            completed.forEach { text += "✓ \($0.attributes.label)\n" }
        }
        
        return text
    }
}

// MARK: - Shopping List Item Row
struct ShoppingListItemRow: View {
    @Binding var item: ListItem
    
    var body: some View {
        HStack {
            Button(action: { item.isCompleted.toggle() }) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(item.attributes.label)
                .strikethrough(item.isCompleted)
                .foregroundColor(item.isCompleted ? .secondary : .primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let text: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview
struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
            .environmentObject(AppState())
    }
}
