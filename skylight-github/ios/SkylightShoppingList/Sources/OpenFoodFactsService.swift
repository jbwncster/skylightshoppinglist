//
//  OpenFoodFactsService.swift
//  SkylightShoppingList
//
//  OpenFoodFacts API Integration using official Swift SDK patterns
//  GitHub: https://github.com/openfoodfacts/openfoodfacts-swift
//

import Foundation
import UIKit

/// OpenFoodFacts API Service
/// Based on the official OpenFoodFacts Swift SDK
/// https://github.com/openfoodfacts/openfoodfacts-swift
class OpenFoodFactsService {
    static let shared = OpenFoodFactsService()
    
    private let baseURL = "https://world.openfoodfacts.org"
    private let session: URLSession
    
    // User agent following OpenFoodFacts guidelines
    private let userAgent = "SkylightShoppingList/1.0 (iOS; https://github.com/YOUR_USERNAME/skylight-shopping-list)"
    
    private init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": userAgent
        ]
        session = URLSession(configuration: config)
    }
    
    // MARK: - Product Search
    
    /// Fetch product by barcode
    /// - Parameter barcode: The product barcode (EAN, UPC, etc.)
    /// - Returns: Product information if found
    func fetchProduct(barcode: String) async throws -> OFFProduct {
        let urlString = "\(baseURL)/api/v2/product/\(barcode)"
        
        guard let url = URL(string: urlString) else {
            throw OFFError.invalidBarcode
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OFFError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw OFFError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let productResponse = try decoder.decode(OFFProductResponse.self, from: data)
        
        guard productResponse.status == 1, let product = productResponse.product else {
            throw OFFError.productNotFound
        }
        
        return product
    }
    
    /// Search products by name
    /// - Parameters:
    ///   - query: Search query
    ///   - page: Page number (optional)
    /// - Returns: Array of products
    func searchProducts(query: String, page: Int = 1) async throws -> [OFFProduct] {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "\(baseURL)/cgi/search.pl?search_terms=\(encodedQuery)&page=\(page)&json=1"
        
        guard let url = URL(string: urlString) else {
            throw OFFError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw OFFError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let searchResponse = try decoder.decode(OFFSearchResponse.self, from: data)
        return searchResponse.products
    }
    
    /// Fetch product image
    /// - Parameter imageURL: URL of the product image
    /// - Returns: UIImage if successfully loaded
    func fetchProductImage(from imageURL: String) async throws -> UIImage {
        guard let url = URL(string: imageURL) else {
            throw OFFError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw OFFError.invalidImageData
        }
        
        return image
    }
}

// MARK: - Data Models

/// OpenFoodFacts Product Response
struct OFFProductResponse: Codable {
    let status: Int
    let code: String
    let product: OFFProduct?
}

/// OpenFoodFacts Search Response
struct OFFSearchResponse: Codable {
    let count: Int
    let page: Int
    let pageCount: Int
    let pageSize: Int
    let products: [OFFProduct]
}

/// OpenFoodFacts Product
/// Follows the OpenFoodFacts data model
/// https://github.com/openfoodfacts/openfoodfacts-swift
struct OFFProduct: Codable, Identifiable {
    var id: String { code }
    
    let code: String
    let productName: String?
    let brands: String?
    let categories: String?
    let imageUrl: String?
    let imageFrontUrl: String?
    let imageIngredientsUrl: String?
    let imageNutritionUrl: String?
    let quantity: String?
    let servingSize: String?
    let ingredientsText: String?
    let allergens: String?
    let traces: String?
    let labels: String?
    let stores: String?
    let countries: String?
    let manufacturingPlaces: String?
    let nutriments: OFFNutriments?
    let nutriscoreGrade: String?
    let novaGroup: Int?
    let ecoscore: String?
    
    enum CodingKeys: String, CodingKey {
        case code
        case productName = "product_name"
        case brands
        case categories
        case imageUrl = "image_url"
        case imageFrontUrl = "image_front_url"
        case imageIngredientsUrl = "image_ingredients_url"
        case imageNutritionUrl = "image_nutrition_url"
        case quantity
        case servingSize = "serving_size"
        case ingredientsText = "ingredients_text"
        case allergens
        case traces
        case labels
        case stores
        case countries
        case manufacturingPlaces = "manufacturing_places"
        case nutriments
        case nutriscoreGrade = "nutriscore_grade"
        case novaGroup = "nova_group"
        case ecoscore = "ecoscore_grade"
    }
}

/// OpenFoodFacts Nutriments
/// Nutritional values per 100g
struct OFFNutriments: Codable {
    let energyKcal100g: Double?
    let energy100g: Double?
    let fat100g: Double?
    let saturatedFat100g: Double?
    let carbohydrates100g: Double?
    let sugars100g: Double?
    let fiber100g: Double?
    let proteins100g: Double?
    let salt100g: Double?
    let sodium100g: Double?
    
    enum CodingKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case energy100g = "energy_100g"
        case fat100g = "fat_100g"
        case saturatedFat100g = "saturated-fat_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case sugars100g = "sugars_100g"
        case fiber100g = "fiber_100g"
        case proteins100g = "proteins_100g"
        case salt100g = "salt_100g"
        case sodium100g = "sodium_100g"
    }
}

// MARK: - Error Types

enum OFFError: LocalizedError {
    case invalidBarcode
    case invalidURL
    case invalidResponse
    case invalidImageData
    case httpError(statusCode: Int)
    case productNotFound
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidBarcode:
            return "Invalid barcode format"
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidImageData:
            return "Invalid image data"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .productNotFound:
            return "Product not found in OpenFoodFacts database"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Extensions

extension OFFProduct {
    /// Convert to local PantryItem
    func toPantryItem(barcode: String, imageData: Data? = nil) -> PantryItem {
        return PantryItem(
            name: productName ?? "Unknown Product",
            quantity: quantity ?? "1",
            category: categorizeProduct(),
            expiryDate: nil,
            imageData: imageData,
            barcode: barcode,
            isInList: false,
            nutritionInfo: nutriments?.toNutritionInfo(brand: brands)
        )
    }
    
    /// Categorize product based on categories string
    private func categorizeProduct() -> String {
        guard let categories = categories?.lowercased() else {
            return ItemCategory.other.rawValue
        }
        
        if categories.contains("fruit") || categories.contains("vegetable") {
            return ItemCategory.produce.rawValue
        } else if categories.contains("dairy") || categories.contains("milk") || 
                  categories.contains("cheese") || categories.contains("yogurt") {
            return ItemCategory.dairy.rawValue
        } else if categories.contains("meat") || categories.contains("fish") || 
                  categories.contains("poultry") {
            return ItemCategory.meat.rawValue
        } else if categories.contains("beverage") || categories.contains("drink") {
            return ItemCategory.beverages.rawValue
        } else if categories.contains("bakery") || categories.contains("bread") {
            return ItemCategory.bakery.rawValue
        } else if categories.contains("snack") {
            return ItemCategory.snacks.rawValue
        } else if categories.contains("frozen") {
            return ItemCategory.frozen.rawValue
        }
        
        return ItemCategory.pantry.rawValue
    }
}

extension OFFNutriments {
    /// Convert to local NutritionInfo
    func toNutritionInfo(brand: String?) -> NutritionInfo {
        return NutritionInfo(
            calories: energyKcal100g.map { String(format: "%.0f kcal", $0) },
            protein: proteins100g.map { String(format: "%.1f g", $0) },
            carbs: carbohydrates100g.map { String(format: "%.1f g", $0) },
            fat: fat100g.map { String(format: "%.1f g", $0) },
            brand: brand,
            ingredients: nil
        )
    }
}

// MARK: - Attribution View

/// OpenFoodFacts Attribution View
/// Required to show attribution per OpenFoodFacts guidelines
struct OpenFoodFactsAttributionView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Powered by")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Link(destination: URL(string: "https://world.openfoodfacts.org")!) {
                HStack(spacing: 8) {
                    Image(systemName: "cart.fill")
                        .foregroundColor(.green)
                    Text("OpenFoodFacts")
                        .fontWeight(.semibold)
                }
            }
            
            Text("Free, open database of food products")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Link("Contribute on GitHub", 
                 destination: URL(string: "https://github.com/openfoodfacts")!)
                .font(.caption)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}
