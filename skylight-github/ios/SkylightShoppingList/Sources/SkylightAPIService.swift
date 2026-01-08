//
//  SkylightAPIService.swift
//  SkylightShoppingList
//
//  API service for communicating with Skylight
//

import Foundation

class SkylightAPIService {
    static let shared = SkylightAPIService()
    
    private let baseURL = "https://app.ourskylight.com"
    
    private init() {}
    
    // MARK: - API Methods
    
    func fetchLists(frameId: String, authToken: String, authType: String) async throws -> [ShoppingList] {
        let url = URL(string: "\(baseURL)/api/frames/\(frameId)/lists")!
        
        var request = URLRequest(url: url)
        request.setValue("\(authType) \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let listsResponse = try decoder.decode(SkylightListsResponse.self, from: data)
        return listsResponse.data
    }
    
    func fetchListDetail(frameId: String, listId: String, authToken: String, authType: String) async throws -> (ShoppingList, [ListItem]) {
        let url = URL(string: "\(baseURL)/api/frames/\(frameId)/lists/\(listId)")!
        
        var request = URLRequest(url: url)
        request.setValue("\(authType) \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(statusCode: httpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        let detailResponse = try decoder.decode(SkylightListDetailResponse.self, from: data)
        return (detailResponse.data, detailResponse.included ?? [])
    }
    
    // MARK: - Error Types
    
    enum APIError: LocalizedError {
        case invalidResponse
        case httpError(statusCode: Int)
        case decodingError
        case networkError(Error)
        
        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return "Invalid response from server"
            case .httpError(let statusCode):
                return "HTTP error: \(statusCode)"
            case .decodingError:
                return "Failed to decode response"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }
}
