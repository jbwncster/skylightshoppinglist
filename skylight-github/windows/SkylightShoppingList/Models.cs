using System.Text.Json.Serialization;

namespace SkylightShoppingList.Models;

/// <summary>
/// Data models for Skylight API (JSON:API format)
/// </summary>

public record SkylightListsResponse(
    [property: JsonPropertyName("data")] List<ShoppingList> Data
);

public record SkylightListDetailResponse(
    [property: JsonPropertyName("data")] ShoppingList Data,
    [property: JsonPropertyName("included")] List<ListItem>? Included = null,
    [property: JsonPropertyName("meta")] Meta? Meta = null
)
{
    public record Meta(
        [property: JsonPropertyName("sections")] List<Section>? Sections = null
    );
    
    public record Section(
        [property: JsonPropertyName("name")] string? Name = null,
        [property: JsonPropertyName("items")] List<string>? Items = null
    );
}

public record ShoppingList(
    [property: JsonPropertyName("type")] string Type,
    [property: JsonPropertyName("id")] string Id,
    [property: JsonPropertyName("attributes")] ShoppingList.Attributes AttributesData,
    [property: JsonPropertyName("relationships")] ShoppingList.Relationships? RelationshipsData = null
)
{
    public record Attributes(
        [property: JsonPropertyName("label")] string Label,
        [property: JsonPropertyName("color")] string? Color = null,
        [property: JsonPropertyName("kind")] string? Kind = null,
        [property: JsonPropertyName("default_grocery_list")] bool? DefaultGroceryList = null
    );
    
    public record Relationships(
        [property: JsonPropertyName("list_items")] ListItemsRelation? ListItems = null
    );
    
    public record ListItemsRelation(
        [property: JsonPropertyName("data")] List<ResourceIdentifier>? Data = null
    );
}

public record ListItem(
    [property: JsonPropertyName("type")] string Type,
    [property: JsonPropertyName("id")] string Id,
    [property: JsonPropertyName("attributes")] ListItem.Attributes AttributesData
)
{
    public record Attributes(
        [property: JsonPropertyName("label")] string Label,
        [property: JsonPropertyName("status")] string Status,
        [property: JsonPropertyName("section")] string? Section = null,
        [property: JsonPropertyName("position")] int? Position = null,
        [property: JsonPropertyName("created_at")] string? CreatedAt = null
    );
    
    public bool IsCompleted => AttributesData.Status == "completed";
}

public record ResourceIdentifier(
    [property: JsonPropertyName("type")] string Type,
    [property: JsonPropertyName("id")] string Id
);

/// <summary>
/// Local models for pantry management
/// </summary>

public class PantryItem
{
    public string Id { get; set; } = Guid.NewGuid().ToString();
    public string Name { get; set; } = string.Empty;
    public string Quantity { get; set; } = "1";
    public ItemCategory Category { get; set; } = ItemCategory.Other;
    public DateTime? ExpiryDate { get; set; }
    public string? ImagePath { get; set; }
    public string? Barcode { get; set; }
    public bool IsInList { get; set; }
    public NutritionInfo? Nutrition { get; set; }
}

public class NutritionInfo
{
    public string? Calories { get; set; }
    public string? Protein { get; set; }
    public string? Carbs { get; set; }
    public string? Fat { get; set; }
    public string? Brand { get; set; }
    public string? Ingredients { get; set; }
}

public enum ItemCategory
{
    Produce,
    Dairy,
    Meat,
    Pantry,
    Frozen,
    Beverages,
    Bakery,
    Snacks,
    Other
}

public static class ItemCategoryExtensions
{
    public static string GetDisplayName(this ItemCategory category) => category switch
    {
        ItemCategory.Produce => "Produce",
        ItemCategory.Dairy => "Dairy",
        ItemCategory.Meat => "Meat & Seafood",
        ItemCategory.Pantry => "Pantry",
        ItemCategory.Frozen => "Frozen",
        ItemCategory.Beverages => "Beverages",
        ItemCategory.Bakery => "Bakery",
        ItemCategory.Snacks => "Snacks",
        _ => "Other"
    };
    
    public static string GetEmoji(this ItemCategory category) => category switch
    {
        ItemCategory.Produce => "🥕",
        ItemCategory.Dairy => "🥛",
        ItemCategory.Meat => "🥩",
        ItemCategory.Pantry => "🥫",
        ItemCategory.Frozen => "🧊",
        ItemCategory.Beverages => "🥤",
        ItemCategory.Bakery => "🥖",
        ItemCategory.Snacks => "🍿",
        _ => "📦"
    };
}

/// <summary>
/// OpenFoodFacts API models
/// </summary>

public record OpenFoodFactsResponse(
    [property: JsonPropertyName("status")] int Status,
    [property: JsonPropertyName("code")] string Code,
    [property: JsonPropertyName("product")] Product? ProductData = null
)
{
    public record Product(
        [property: JsonPropertyName("product_name")] string? ProductName = null,
        [property: JsonPropertyName("brands")] string? Brands = null,
        [property: JsonPropertyName("categories")] string? Categories = null,
        [property: JsonPropertyName("image_url")] string? ImageUrl = null,
        [property: JsonPropertyName("nutriments")] Nutriments? NutrimentsData = null,
        [property: JsonPropertyName("ingredients_text")] string? IngredientsText = null
    );
    
    public record Nutriments(
        [property: JsonPropertyName("energy-kcal_100g")] double? EnergyKcal100g = null,
        [property: JsonPropertyName("proteins_100g")] double? Proteins100g = null,
        [property: JsonPropertyName("carbohydrates_100g")] double? Carbohydrates100g = null,
        [property: JsonPropertyName("fat_100g")] double? Fat100g = null
    );
}

/// <summary>
/// Auth configuration
/// </summary>

public class AuthConfig
{
    public string FrameId { get; set; } = string.Empty;
    public string AuthToken { get; set; } = string.Empty;
    public AuthType AuthType { get; set; } = AuthType.Bearer;
}

public enum AuthType
{
    Bearer,
    Basic
}

/// <summary>
/// Camera scan result
/// </summary>

public class ScanResult
{
    public List<string> DetectedItems { get; set; } = new();
    public string ImagePath { get; set; } = string.Empty;
    public Dictionary<string, float> Confidence { get; set; } = new();
}
