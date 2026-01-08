package com.skylight.shoppinglist.data.repository

import com.skylight.shoppinglist.data.api.OpenFoodFactsApiService
import com.skylight.shoppinglist.data.api.SkylightApiService
import com.skylight.shoppinglist.data.model.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import javax.inject.Inject
import javax.inject.Singleton

/**
 * Repository for Skylight API operations
 */
@Singleton
class SkylightRepository @Inject constructor(
    private val apiService: SkylightApiService
) {
    
    suspend fun fetchLists(authConfig: AuthConfig): Result<List<ShoppingList>> =
        withContext(Dispatchers.IO) {
            try {
                val authHeader = "${authConfig.authType.value} ${authConfig.authToken}"
                val response = apiService.getLists(authConfig.frameId, authHeader)
                
                if (response.isSuccessful && response.body() != null) {
                    Result.success(response.body()!!.data)
                } else {
                    Result.failure(Exception("HTTP ${response.code()}: ${response.message()}"))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
    
    suspend fun fetchListDetail(
        authConfig: AuthConfig,
        listId: String
    ): Result<Pair<ShoppingList, List<ListItem>>> = withContext(Dispatchers.IO) {
        try {
            val authHeader = "${authConfig.authType.value} ${authConfig.authToken}"
            val response = apiService.getListDetail(
                authConfig.frameId,
                listId,
                authHeader
            )
            
            if (response.isSuccessful && response.body() != null) {
                val body = response.body()!!
                val items = body.included?.sortedBy { it.attributes.position ?: 0 } ?: emptyList()
                Result.success(body.data to items)
            } else {
                Result.failure(Exception("HTTP ${response.code()}: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}

/**
 * Repository for OpenFoodFacts API operations
 */
@Singleton
class OpenFoodFactsRepository @Inject constructor(
    private val apiService: OpenFoodFactsApiService
) {
    
    suspend fun getProductByBarcode(barcode: String): Result<ProductInfo> =
        withContext(Dispatchers.IO) {
            try {
                val response = apiService.getProduct(barcode)
                
                if (response.isSuccessful && response.body()?.product != null) {
                    val product = response.body()!!.product!!
                    Result.success(
                        ProductInfo(
                            name = product.productName ?: "Unknown Product",
                            brand = product.brands,
                            category = product.categories,
                            imageUrl = product.imageUrl,
                            nutritionInfo = product.nutriments?.let {
                                NutritionInfo(
                                    calories = it.energyKcal100g?.toString(),
                                    protein = it.proteins100g?.toString(),
                                    carbs = it.carbohydrates100g?.toString(),
                                    fat = it.fat100g?.toString(),
                                    brand = product.brands,
                                    ingredients = product.ingredientsText
                                )
                            }
                        )
                    )
                } else {
                    Result.failure(Exception("Product not found"))
                }
            } catch (e: Exception) {
                Result.failure(e)
            }
        }
}

data class ProductInfo(
    val name: String,
    val brand: String?,
    val category: String?,
    val imageUrl: String?,
    val nutritionInfo: NutritionInfo?
)

/**
 * Local data repository for pantry items
 */
@Singleton
class PantryRepository @Inject constructor(
    private val dataStore: androidx.datastore.core.DataStore<androidx.datastore.preferences.core.Preferences>
) {
    
    private val pantryItemsKey = androidx.datastore.preferences.core.stringPreferencesKey("pantry_items")
    
    suspend fun getPantryItems(): List<PantryItem> = withContext(Dispatchers.IO) {
        try {
            dataStore.data.map { preferences ->
                val json = preferences[pantryItemsKey] ?: "[]"
                kotlinx.serialization.json.Json.decodeFromString<List<PantryItem>>(json)
            }.first()
        } catch (e: Exception) {
            emptyList()
        }
    }
    
    suspend fun savePantryItems(items: List<PantryItem>) = withContext(Dispatchers.IO) {
        try {
            dataStore.edit { preferences ->
                val json = kotlinx.serialization.json.Json.encodeToString(
                    kotlinx.serialization.builtins.ListSerializer(PantryItem.serializer()),
                    items
                )
                preferences[pantryItemsKey] = json
            }
        } catch (e: Exception) {
            // Handle error
        }
    }
    
    suspend fun addPantryItem(item: PantryItem) {
        val currentItems = getPantryItems().toMutableList()
        currentItems.add(item)
        savePantryItems(currentItems)
    }
    
    suspend fun removePantryItem(itemId: String) {
        val currentItems = getPantryItems().filter { it.id != itemId }
        savePantryItems(currentItems)
    }
    
    suspend fun updatePantryItem(item: PantryItem) {
        val currentItems = getPantryItems().map {
            if (it.id == item.id) item else it
        }
        savePantryItems(currentItems)
    }
}
