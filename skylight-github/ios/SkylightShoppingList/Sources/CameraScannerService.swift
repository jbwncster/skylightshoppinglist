//
//  CameraScannerService.swift
//  SkylightShoppingList
//
//  Uses Vision and CoreML to detect items in fridge/pantry photos
//

import Foundation
import Vision
import UIKit
import CoreML

class CameraScannerService: ObservableObject {
    static let shared = CameraScannerService()
    
    @Published var isScanning = false
    @Published var scanProgress: Double = 0.0
    
    private init() {}
    
    // MARK: - Scan Image for Food Items
    
    func scanImage(_ image: UIImage) async throws -> ScanResult {
        isScanning = true
        scanProgress = 0.1
        
        guard let ciImage = CIImage(image: image) else {
            throw ScanError.invalidImage
        }
        
        var detectedItems: [String] = []
        var confidence: [String: Double] = [:]
        
        // Use Vision for text recognition (labels on packages)
        let textItems = try await detectText(in: image)
        detectedItems.append(contentsOf: textItems)
        scanProgress = 0.4
        
        // Use Vision for object detection (food items)
        let objectItems = try await detectObjects(in: ciImage)
        detectedItems.append(contentsOf: objectItems.map { $0.name })
        objectItems.forEach { confidence[$0.name] = $0.confidence }
        scanProgress = 0.7
        
        // Process and clean up detected items
        let cleanedItems = processDetectedItems(detectedItems)
        scanProgress = 1.0
        
        isScanning = false
        
        return ScanResult(
            detectedItems: cleanedItems,
            image: image,
            confidence: confidence
        )
    }
    
    // MARK: - Text Recognition
    
    private func detectText(in image: UIImage) async throws -> [String] {
        return try await withCheckedThrowingContinuation { continuation in
            guard let cgImage = image.cgImage else {
                continuation.resume(throwing: ScanError.invalidImage)
                return
            }
            
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: [])
                    return
                }
                
                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }
                
                // Filter for food-related words
                let foodItems = self.filterFoodItems(from: recognizedStrings)
                continuation.resume(returning: foodItems)
            }
            
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Object Detection
    
    private func detectObjects(in ciImage: CIImage) async throws -> [(name: String, confidence: Double)] {
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeAnimalsRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                // For demo purposes, we'll use a simple object detector
                // In production, you'd use a custom CoreML model trained on food items
                continuation.resume(returning: self.getCommonFoodItems())
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func filterFoodItems(from strings: [String]) -> [String] {
        let foodKeywords = [
            "milk", "eggs", "bread", "cheese", "butter", "yogurt",
            "chicken", "beef", "pork", "fish", "salmon", "turkey",
            "apple", "banana", "orange", "lettuce", "tomato", "carrot",
            "potato", "onion", "garlic", "pepper", "broccoli", "spinach",
            "rice", "pasta", "flour", "sugar", "salt", "oil",
            "juice", "soda", "water", "coffee", "tea",
            "cereal", "oatmeal", "crackers", "chips", "cookies"
        ]
        
        var detected: [String] = []
        
        for string in strings {
            let lowerString = string.lowercased()
            for keyword in foodKeywords {
                if lowerString.contains(keyword) {
                    detected.append(keyword.capitalized)
                }
            }
        }
        
        return Array(Set(detected)) // Remove duplicates
    }
    
    private func getCommonFoodItems() -> [(name: String, confidence: Double)] {
        // This is a simplified version. In production, use a custom CoreML model
        // trained on food items for better accuracy
        return []
    }
    
    private func processDetectedItems(_ items: [String]) -> [String] {
        // Remove duplicates and clean up
        var uniqueItems = Array(Set(items))
        uniqueItems.sort()
        return uniqueItems
    }
    
    // MARK: - Manual Item Recognition
    
    func suggestCategory(for itemName: String) -> String {
        let lowerName = itemName.lowercased()
        
        if lowerName.contains("milk") || lowerName.contains("cheese") || 
           lowerName.contains("yogurt") || lowerName.contains("butter") {
            return ItemCategory.dairy.rawValue
        } else if lowerName.contains("apple") || lowerName.contains("banana") || 
                  lowerName.contains("orange") || lowerName.contains("lettuce") ||
                  lowerName.contains("tomato") || lowerName.contains("carrot") {
            return ItemCategory.produce.rawValue
        } else if lowerName.contains("chicken") || lowerName.contains("beef") || 
                  lowerName.contains("pork") || lowerName.contains("fish") {
            return ItemCategory.meat.rawValue
        } else if lowerName.contains("bread") || lowerName.contains("bagel") {
            return ItemCategory.bakery.rawValue
        } else if lowerName.contains("ice cream") || lowerName.contains("frozen") {
            return ItemCategory.frozen.rawValue
        } else if lowerName.contains("juice") || lowerName.contains("soda") || 
                  lowerName.contains("water") || lowerName.contains("coffee") {
            return ItemCategory.beverages.rawValue
        } else if lowerName.contains("chips") || lowerName.contains("cookies") || 
                  lowerName.contains("crackers") {
            return ItemCategory.snacks.rawValue
        } else if lowerName.contains("rice") || lowerName.contains("pasta") || 
                  lowerName.contains("flour") || lowerName.contains("sugar") {
            return ItemCategory.pantry.rawValue
        }
        
        return ItemCategory.other.rawValue
    }
    
    // MARK: - Error Types
    
    enum ScanError: LocalizedError {
        case invalidImage
        case scanFailed
        case noItemsDetected
        
        var errorDescription: String? {
            switch self {
            case .invalidImage:
                return "Invalid image format"
            case .scanFailed:
                return "Failed to scan image"
            case .noItemsDetected:
                return "No items detected in image"
            }
        }
    }
}
