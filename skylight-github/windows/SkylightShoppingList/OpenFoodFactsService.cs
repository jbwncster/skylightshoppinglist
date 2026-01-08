using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace SkylightShoppingList.Services;

/// <summary>
/// OpenFoodFacts API Service for Windows
/// 
/// Official API: https://openfoodfacts.github.io/openfoodfacts-server/api/
/// GitHub Organization: https://github.com/openfoodfacts
/// Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
/// Android App: https://github.com/openfoodfacts/openfoodfacts-androidapp
/// 
/// Attribution Required: Per ODbL license, attribution must be shown in app
/// User-Agent Required: Include app name and URL in User-Agent header
/// </summary>
public interface IOpenFoodFactsService
{
    Task<OFFProduct?> GetProductAsync(string barcode);
    Task<List<OFFProduct>> SearchProductsAsync(string query, int page = 1);
    Task<byte[]?> GetProductImageAsync(string imageUrl);
}

public class OpenFoodFactsService : IOpenFoodFactsService
{
    private readonly HttpClient _httpClient;
    private const string BaseUrl = "https://world.openfoodfacts.org";
    
    // User-Agent following OpenFoodFacts guidelines
    // Format: AppName/Version (Platform; URL)
    private const string UserAgent = "SkylightShoppingList/1.0 (Windows; https://github.com/YOUR_USERNAME/skylight-shopping-list)";
    
    public OpenFoodFactsService()
    {
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri(BaseUrl)
        };
        _httpClient.DefaultRequestHeaders.Add("User-Agent", UserAgent);
        _httpClient.DefaultRequestHeaders.Add("Accept", "application/json");
    }
    
    /// <summary>
    /// Fetch product by barcode
    /// </summary>
    public async Task<OFFProduct?> GetProductAsync(string barcode)
    {
        try
        {
            var response = await _httpClient.GetFromJsonAsync<OFFProductResponse>(
                $"/api/v2/product/{barcode}",
                new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
                }
            );
            
            if (response?.Status == 1 && response.Product != null)
            {
                return response.Product;
            }
            
            return null;
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"OpenFoodFacts error: {ex.Message}");
            return null;
        }
    }
    
    /// <summary>
    /// Search products by name
    /// </summary>
    public async Task<List<OFFProduct>> SearchProductsAsync(string query, int page = 1)
    {
        try
        {
            var encodedQuery = Uri.EscapeDataString(query);
            var url = $"/cgi/search.pl?search_terms={encodedQuery}&page={page}&json=1";
            
            var response = await _httpClient.GetFromJsonAsync<OFFSearchResponse>(
                url,
                new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
                    DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull
                }
            );
            
            return response?.Products ?? new List<OFFProduct>();
        }
        catch (Exception ex)
        {
            System.Diagnostics.Debug.WriteLine($"OpenFoodFacts search error: {ex.Message}");
            return new List<OFFProduct>();
        }
    }
    
    /// <summary>
    /// Download product image
    /// </summary>
    public async Task<byte[]?> GetProductImageAsync(string imageUrl)
    {
        try
        {
            return await _httpClient.GetByteArrayAsync(imageUrl);
        }
        catch
        {
            return null;
        }
    }
}

#region Data Models

/// <summary>
/// OpenFoodFacts Product Response
/// Based on API v2 schema
/// </summary>
public record OFFProductResponse
{
    [JsonPropertyName("status")]
    public int Status { get; init; }
    
    [JsonPropertyName("code")]
    public string Code { get; init; } = string.Empty;
    
    [JsonPropertyName("product")]
    public OFFProduct? Product { get; init; }
}

/// <summary>
/// OpenFoodFacts Search Response
/// </summary>
public record OFFSearchResponse
{
    [JsonPropertyName("count")]
    public int Count { get; init; }
    
    [JsonPropertyName("page")]
    public int Page { get; init; }
    
    [JsonPropertyName("page_count")]
    public int PageCount { get; init; }
    
    [JsonPropertyName("page_size")]
    public int PageSize { get; init; }
    
    [JsonPropertyName("products")]
    public List<OFFProduct> Products { get; init; } = new();
}

/// <summary>
/// OpenFoodFacts Product
/// Comprehensive data model matching official API
/// Reference: https://github.com/openfoodfacts/openfoodfacts-swift
/// </summary>
public record OFFProduct
{
    [JsonPropertyName("code")]
    public string Code { get; init; } = string.Empty;
    
    [JsonPropertyName("product_name")]
    public string? ProductName { get; init; }
    
    [JsonPropertyName("brands")]
    public string? Brands { get; init; }
    
    [JsonPropertyName("categories")]
    public string? Categories { get; init; }
    
    [JsonPropertyName("image_url")]
    public string? ImageUrl { get; init; }
    
    [JsonPropertyName("image_front_url")]
    public string? ImageFrontUrl { get; init; }
    
    [JsonPropertyName("image_ingredients_url")]
    public string? ImageIngredientsUrl { get; init; }
    
    [JsonPropertyName("image_nutrition_url")]
    public string? ImageNutritionUrl { get; init; }
    
    [JsonPropertyName("quantity")]
    public string? Quantity { get; init; }
    
    [JsonPropertyName("serving_size")]
    public string? ServingSize { get; init; }
    
    [JsonPropertyName("ingredients_text")]
    public string? IngredientsText { get; init; }
    
    [JsonPropertyName("allergens")]
    public string? Allergens { get; init; }
    
    [JsonPropertyName("traces")]
    public string? Traces { get; init; }
    
    [JsonPropertyName("labels")]
    public string? Labels { get; init; }
    
    [JsonPropertyName("stores")]
    public string? Stores { get; init; }
    
    [JsonPropertyName("countries")]
    public string? Countries { get; init; }
    
    [JsonPropertyName("manufacturing_places")]
    public string? ManufacturingPlaces { get; init; }
    
    [JsonPropertyName("nutriments")]
    public OFFNutriments? Nutriments { get; init; }
    
    [JsonPropertyName("nutriscore_grade")]
    public string? NutriscoreGrade { get; init; }
    
    [JsonPropertyName("nova_group")]
    public int? NovaGroup { get; init; }
    
    [JsonPropertyName("ecoscore_grade")]
    public string? EcoscoreGrade { get; init; }
}

/// <summary>
/// Nutriments per 100g
/// </summary>
public record OFFNutriments
{
    [JsonPropertyName("energy-kcal_100g")]
    public double? EnergyKcal100g { get; init; }
    
    [JsonPropertyName("energy_100g")]
    public double? Energy100g { get; init; }
    
    [JsonPropertyName("fat_100g")]
    public double? Fat100g { get; init; }
    
    [JsonPropertyName("saturated-fat_100g")]
    public double? SaturatedFat100g { get; init; }
    
    [JsonPropertyName("carbohydrates_100g")]
    public double? Carbohydrates100g { get; init; }
    
    [JsonPropertyName("sugars_100g")]
    public double? Sugars100g { get; init; }
    
    [JsonPropertyName("fiber_100g")]
    public double? Fiber100g { get; init; }
    
    [JsonPropertyName("proteins_100g")]
    public double? Proteins100g { get; init; }
    
    [JsonPropertyName("salt_100g")]
    public double? Salt100g { get; init; }
    
    [JsonPropertyName("sodium_100g")]
    public double? Sodium100g { get; init; }
}

#endregion

#region Extension Methods

/// <summary>
/// Extension methods for converting OpenFoodFacts data to local models
/// </summary>
public static class OFFExtensions
{
    public static PantryItem ToPantryItem(this OFFProduct product)
    {
        return new PantryItem
        {
            Name = product.ProductName ?? "Unknown Product",
            Quantity = product.Quantity ?? "1",
            Category = product.CategorizeProduct(),
            Barcode = product.Code,
            Nutrition = product.Nutriments?.ToNutritionInfo(product.Brands)
        };
    }
    
    public static ItemCategory CategorizeProduct(this OFFProduct product)
    {
        var categories = product.Categories?.ToLowerInvariant() ?? string.Empty;
        
        if (categories.Contains("fruit") || categories.Contains("vegetable"))
            return ItemCategory.Produce;
        if (categories.Contains("dairy") || categories.Contains("milk") || categories.Contains("cheese"))
            return ItemCategory.Dairy;
        if (categories.Contains("meat") || categories.Contains("fish") || categories.Contains("poultry"))
            return ItemCategory.Meat;
        if (categories.Contains("beverage") || categories.Contains("drink"))
            return ItemCategory.Beverages;
        if (categories.Contains("bakery") || categories.Contains("bread"))
            return ItemCategory.Bakery;
        if (categories.Contains("snack"))
            return ItemCategory.Snacks;
        if (categories.Contains("frozen"))
            return ItemCategory.Frozen;
        
        return ItemCategory.Pantry;
    }
    
    public static NutritionInfo ToNutritionInfo(this OFFNutriments nutriments, string? brand)
    {
        return new NutritionInfo
        {
            Calories = nutriments.EnergyKcal100g?.ToString("F0") + " kcal",
            Protein = nutriments.Proteins100g?.ToString("F1") + " g",
            Carbs = nutriments.Carbohydrates100g?.ToString("F1") + " g",
            Fat = nutriments.Fat100g?.ToString("F1") + " g",
            Brand = brand
        };
    }
}

#endregion

#region Attribution Component (XAML Usage)

/// <summary>
/// OpenFoodFacts Attribution View Model
/// 
/// Usage in XAML:
/// <local:OpenFoodFactsAttributionView />
/// </summary>
public class OpenFoodFactsAttributionViewModel
{
    public string Title => "Powered by Open Food Facts";
    public string Description => "Free, open database of food products from around the world";
    public string Website => "https://world.openfoodfacts.org";
    public string GitHubOrg => "https://github.com/openfoodfacts";
    public string SwiftSDK => "https://github.com/openfoodfacts/openfoodfacts-swift";
    public string AndroidApp => "https://github.com/openfoodfacts/openfoodfacts-androidapp";
    public string License => "Open Database License (ODbL)";
    
    public List<StatItem> Stats => new()
    {
        new StatItem { Label = "3M+", Description = "Products" },
        new StatItem { Label = "180+", Description = "Countries" },
        new StatItem { Label = "Free", Description = "Forever" }
    };
    
    public class StatItem
    {
        public string Label { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
    }
}

#endregion
