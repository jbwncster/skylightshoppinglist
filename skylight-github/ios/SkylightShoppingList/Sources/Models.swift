//
//  Models.swift
//  SkylightShoppingList
//
//  Data models for Skylight API integration
//

import Foundation
import SwiftUI

// MARK: - Skylight API Models (JSON:API format)

struct SkylightListsResponse: Codable {
    let data: [ShoppingList]
}

struct SkylightListDetailResponse: Codable {
    let data: ShoppingList
    let included: [ListItem]?
    let meta: Meta?
    
    struct Meta: Codable {
        let sections: [Section]?
    }
    
    struct Section: Codable {
        let name: String?
        let items: [String]?
    }
}

struct ShoppingList: Codable, Identifiable {
    let type: String
    let id: String
    let attributes: Attributes
    let relationships: Relationships?
    
    struct Attributes: Codable {
        let label: String
        let color: String?
        let kind: String?
        let defaultGroceryList: Bool?
        
        enum CodingKeys: String, CodingKey {
            case label, color, kind
            case defaultGroceryList = "default_grocery_list"
        }
    }
    
    struct Relationships: Codable {
        let listItems: ListItemsRelation?
        
        enum CodingKeys: String, CodingKey {
            case listItems = "list_items"
        }
    }
    
    struct ListItemsRelation: Codable {
        let data: [ResourceIdentifier]?
    }
}

struct ListItem: Codable, Identifiable {
    let type: String
    let id: String
    var attributes: Attributes
    
    struct Attributes: Codable {
        let label: String
        var status: String
        let section: String?
        let position: Int?
        let createdAt: String?
        
        enum CodingKeys: String, CodingKey {
            case label, status, section, position
            case createdAt = "created_at"
        }
    }
    
    var isCompleted: Bool {
        get { attributes.status == "completed" }
        set { attributes.status = newValue ? "completed" : "pending" }
    }
}

struct ResourceIdentifier: Codable {
    let type: String
    let id: String
}

// MARK: - Local Models

struct PantryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var quantity: String
    var category: String
    var expiryDate: Date?
    var imageData: Data?
    var isInList: Bool
    
    init(id: UUID = UUID(), name: String, quantity: String = "1", category: String = "Other", expiryDate: Date? = nil, imageData: Data? = nil, isInList: Bool = false) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.expiryDate = expiryDate
        self.imageData = imageData
        self.isInList = isInList
    }
}

enum ItemCategory: String, CaseIterable {
    case produce = "Produce"
    case dairy = "Dairy"
    case meat = "Meat & Seafood"
    case pantry = "Pantry"
    case frozen = "Frozen"
    case beverages = "Beverages"
    case bakery = "Bakery"
    case snacks = "Snacks"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .produce: return "🥕"
        case .dairy: return "🥛"
        case .meat: return "🥩"
        case .pantry: return "🥫"
        case .frozen: return "🧊"
        case .beverages: return "🥤"
        case .bakery: return "🥖"
        case .snacks: return "🍿"
        case .other: return "📦"
        }
    }
}

// MARK: - Camera Scan Result
struct ScanResult {
    let detectedItems: [String]
    let image: UIImage
    let confidence: [String: Double]
}
