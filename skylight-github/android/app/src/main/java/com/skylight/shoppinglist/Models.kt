package com.skylight.shoppinglist.data.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * Data models for Skylight API (JSON:API format)
 */

@Serializable
data class SkylightListsResponse(
    val data: List<ShoppingList>
)

@Serializable
data class SkylightListDetailResponse(
    val data: ShoppingList,
    val included: List<ListItem>? = null,
    val meta: Meta? = null
) {
    @Serializable
    data class Meta(
        val sections: List<Section>? = null
    )
    
    @Serializable
    data class Section(
        val name: String? = null,
        val items: List<String>? = null
    )
}

@Serializable
data class ShoppingList(
    val type: String,
    val id: String,
    val attributes: Attributes,
    val relationships: Relationships? = null
) {
    @Serializable
    data class Attributes(
        val label: String,
        val color: String? = null,
        val kind: String? = null,
        @SerialName("default_grocery_list")
        val defaultGroceryList: Boolean? = null
    )
    
    @Serializable
    data class Relationships(
        @SerialName("list_items")
        val listItems: ListItemsRelation? = null
    )
    
    @Serializable
    data class ListItemsRelation(
        val data: List<ResourceIdentifier>? = null
    )
}

@Serializable
data class ListItem(
    val type: String,
    val id: String,
    val attributes: Attributes
) {
    @Serializable
    data class Attributes(
        val label: String,
        var status: String,
        val section: String? = null,
        val position: Int? = null,
        @SerialName("created_at")
        val createdAt: String? = null
    )
    
    val isCompleted: Boolean
        get() = attributes.status == "completed"
}

@Serializable
data class ResourceIdentifier(
    val type: String,
    val id: String
)

/**
 * Local models for pantry management
 */

data class PantryItem(
    val id: String,
    val name: String,
    val quantity: String,
    val category: ItemCategory,
    val expiryDate: Long? = null,
    val imageUri: String? = null,
    val barcode: String? = null,
    val isInList: Boolean = false,
    val nutritionInfo: NutritionInfo? = null
)

data class NutritionInfo(
    val calories: String? = null,
    val protein: String? = null,
    val carbs: String? = null,
    val fat: String? = null,
    val brand: String? = null,
    val ingredients: String? = null
)

enum class ItemCategory(val displayName: String, val emoji: String) {
    PRODUCE("Produce", "🥕"),
    DAIRY("Dairy", "🥛"),
    MEAT("Meat & Seafood", "🥩"),
    PANTRY("Pantry", "🥫"),
    FROZEN("Frozen", "🧊"),
    BEVERAGES("Beverages", "🥤"),
    BAKERY("Bakery", "🥖"),
    SNACKS("Snacks", "🍿"),
    OTHER("Other", "📦")
}

/**
 * OpenFoodFacts API models
 */

@Serializable
data class OpenFoodFactsResponse(
    val status: Int,
    val code: String,
    val product: Product? = null
) {
    @Serializable
    data class Product(
        @SerialName("product_name")
        val productName: String? = null,
        val brands: String? = null,
        val categories: String? = null,
        @SerialName("image_url")
        val imageUrl: String? = null,
        val nutriments: Nutriments? = null,
        @SerialName("ingredients_text")
        val ingredientsText: String? = null
    )
    
    @Serializable
    data class Nutriments(
        @SerialName("energy-kcal_100g")
        val energyKcal100g: Double? = null,
        @SerialName("proteins_100g")
        val proteins100g: Double? = null,
        @SerialName("carbohydrates_100g")
        val carbohydrates100g: Double? = null,
        @SerialName("fat_100g")
        val fat100g: Double? = null
    )
}

/**
 * Camera scan result
 */

data class ScanResult(
    val detectedItems: List<String>,
    val imageUri: String,
    val confidence: Map<String, Float>
)

/**
 * Auth configuration
 */

data class AuthConfig(
    val frameId: String,
    val authToken: String,
    val authType: AuthType
)

enum class AuthType(val value: String) {
    BEARER("Bearer"),
    BASIC("Basic")
}
