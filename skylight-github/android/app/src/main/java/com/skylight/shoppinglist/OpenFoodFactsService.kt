package com.skylight.shoppinglist.data.api

import com.skylight.shoppinglist.data.model.OpenFoodFactsResponse
import retrofit2.Response
import retrofit2.http.*

/**
 * OpenFoodFacts API Service for Android
 * 
 * Official API Documentation: https://openfoodfacts.github.io/openfoodfacts-server/api/
 * GitHub: https://github.com/openfoodfacts/openfoodfacts-androidapp
 * Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
 * 
 * Usage Guidelines:
 * - Set proper User-Agent header
 * - Respect rate limits
 * - Contribute back when possible
 * - Show attribution in app
 */
interface OpenFoodFactsApiService {
    
    /**
     * Get product by barcode
     * @param barcode Product barcode (EAN, UPC, etc.)
     * @param fields Optional: Comma-separated list of fields to return
     */
    @GET("api/v2/product/{barcode}")
    suspend fun getProduct(
        @Path("barcode") barcode: String,
        @Query("fields") fields: String? = null
    ): Response<OpenFoodFactsResponse>
    
    /**
     * Search products
     * @param query Search query
     * @param page Page number (default: 1)
     * @param pageSize Number of results per page
     */
    @GET("cgi/search.pl")
    suspend fun searchProducts(
        @Query("search_terms") query: String,
        @Query("page") page: Int = 1,
        @Query("page_size") pageSize: Int = 20,
        @Query("json") json: Int = 1
    ): Response<OpenFoodFactsSearchResponse>
    
    companion object {
        const val BASE_URL = "https://world.openfoodfacts.org/"
        
        // User agent following OpenFoodFacts guidelines
        // Format: AppName/Version (Platform; URL)
        const val USER_AGENT = "SkylightShoppingList/1.0 (Android; https://github.com/YOUR_USERNAME/skylight-shopping-list)"
    }
}

/**
 * OpenFoodFacts Search Response
 */
@kotlinx.serialization.Serializable
data class OpenFoodFactsSearchResponse(
    val count: Int,
    val page: Int,
    @kotlinx.serialization.SerialName("page_count")
    val pageCount: Int,
    @kotlinx.serialization.SerialName("page_size")
    val pageSize: Int,
    val products: List<OpenFoodFactsProduct>
)

/**
 * Extended OpenFoodFacts Product Model
 * Based on official API schema
 */
@kotlinx.serialization.Serializable
data class OpenFoodFactsProduct(
    val code: String,
    @kotlinx.serialization.SerialName("product_name")
    val productName: String? = null,
    val brands: String? = null,
    val categories: String? = null,
    @kotlinx.serialization.SerialName("image_url")
    val imageUrl: String? = null,
    @kotlinx.serialization.SerialName("image_front_url")
    val imageFrontUrl: String? = null,
    @kotlinx.serialization.SerialName("image_ingredients_url")
    val imageIngredientsUrl: String? = null,
    @kotlinx.serialization.SerialName("image_nutrition_url")
    val imageNutritionUrl: String? = null,
    val quantity: String? = null,
    @kotlinx.serialization.SerialName("serving_size")
    val servingSize: String? = null,
    @kotlinx.serialization.SerialName("ingredients_text")
    val ingredientsText: String? = null,
    val allergens: String? = null,
    val traces: String? = null,
    val labels: String? = null,
    val stores: String? = null,
    val countries: String? = null,
    @kotlinx.serialization.SerialName("manufacturing_places")
    val manufacturingPlaces: String? = null,
    val nutriments: OpenFoodFactsNutriments? = null,
    @kotlinx.serialization.SerialName("nutriscore_grade")
    val nutriscoreGrade: String? = null,
    @kotlinx.serialization.SerialName("nova_group")
    val novaGroup: Int? = null,
    @kotlinx.serialization.SerialName("ecoscore_grade")
    val ecoscoreGrade: String? = null
)

/**
 * Nutriments (per 100g)
 */
@kotlinx.serialization.Serializable
data class OpenFoodFactsNutriments(
    @kotlinx.serialization.SerialName("energy-kcal_100g")
    val energyKcal100g: Double? = null,
    @kotlinx.serialization.SerialName("energy_100g")
    val energy100g: Double? = null,
    @kotlinx.serialization.SerialName("fat_100g")
    val fat100g: Double? = null,
    @kotlinx.serialization.SerialName("saturated-fat_100g")
    val saturatedFat100g: Double? = null,
    @kotlinx.serialization.SerialName("carbohydrates_100g")
    val carbohydrates100g: Double? = null,
    @kotlinx.serialization.SerialName("sugars_100g")
    val sugars100g: Double? = null,
    @kotlinx.serialization.SerialName("fiber_100g")
    val fiber100g: Double? = null,
    @kotlinx.serialization.SerialName("proteins_100g")
    val proteins100g: Double? = null,
    @kotlinx.serialization.SerialName("salt_100g")
    val salt100g: Double? = null,
    @kotlinx.serialization.SerialName("sodium_100g")
    val sodium100g: Double? = null
)

/**
 * Repository implementation with proper attribution
 */
class OpenFoodFactsRepository @Inject constructor(
    private val apiService: OpenFoodFactsApiService
) {
    
    suspend fun getProductByBarcode(barcode: String): Result<ProductInfo> =
        withContext(Dispatchers.IO) {
            try {
                val response = apiService.getProduct(barcode)
                
                if (response.isSuccessful && response.body()?.product != null) {
                    val product = response.body()!!.product!!
                    Result.success(product.toProductInfo())
                } else {
                    Result.failure(Exception("Product not found in OpenFoodFacts database"))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    
    suspend fun searchProducts(query: String, page: Int = 1): Result<List<ProductInfo>> =
        withContext(Dispatchers.IO) {
            try {
                val response = apiService.searchProducts(query, page)
                
                if (response.isSuccessful && response.body() != null) {
                    val products = response.body()!!.products.map { it.toProductInfo() }
                    Result.success(products)
                } else {
                    Result.failure(Exception("Search failed"))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
}

// Extension functions for conversion
fun OpenFoodFactsProduct.toProductInfo(): ProductInfo {
    return ProductInfo(
        name = productName ?: "Unknown Product",
        brand = brands,
        category = categories,
        imageUrl = imageFrontUrl ?: imageUrl,
        barcode = code,
        nutritionInfo = nutriments?.toNutritionInfo(brands)
    )
}

fun OpenFoodFactsNutriments.toNutritionInfo(brand: String?): NutritionInfo {
    return NutritionInfo(
        calories = energyKcal100g?.let { "%.0f kcal".format(it) },
        protein = proteins100g?.let { "%.1f g".format(it) },
        carbs = carbohydrates100g?.let { "%.1f g".format(it) },
        fat = fat100g?.let { "%.1f g".format(it) },
        brand = brand,
        ingredients = null
    )
}

fun OpenFoodFactsProduct.toPantryItem(): PantryItem {
    return PantryItem(
        id = java.util.UUID.randomUUID().toString(),
        name = productName ?: "Unknown Product",
        quantity = quantity ?: "1",
        category = categorizeProduct(),
        expiryDate = null,
        imageUri = imageFrontUrl ?: imageUrl,
        barcode = code,
        isInList = false,
        nutritionInfo = nutriments?.toNutritionInfo(brands)
    )
}

fun OpenFoodFactsProduct.categorizeProduct(): ItemCategory {
    val cats = categories?.lowercase() ?: return ItemCategory.OTHER
    
    return when {
        "fruit" in cats || "vegetable" in cats -> ItemCategory.PRODUCE
        "dairy" in cats || "milk" in cats || "cheese" in cats -> ItemCategory.DAIRY
        "meat" in cats || "fish" in cats || "poultry" in cats -> ItemCategory.MEAT
        "beverage" in cats || "drink" in cats -> ItemCategory.BEVERAGES
        "bakery" in cats || "bread" in cats -> ItemCategory.BAKERY
        "snack" in cats -> ItemCategory.SNACKS
        "frozen" in cats -> ItemCategory.FROZEN
        else -> ItemCategory.PANTRY
    }
}
