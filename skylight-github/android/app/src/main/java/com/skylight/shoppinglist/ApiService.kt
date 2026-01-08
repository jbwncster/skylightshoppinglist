package com.skylight.shoppinglist.data.api

import com.skylight.shoppinglist.data.model.*
import retrofit2.Response
import retrofit2.http.*

/**
 * Skylight API Service using Retrofit
 */
interface SkylightApiService {
    
    @GET("api/frames/{frameId}/lists")
    suspend fun getLists(
        @Path("frameId") frameId: String,
        @Header("Authorization") authorization: String,
        @Header("Accept") accept: String = "application/json"
    ): Response<SkylightListsResponse>
    
    @GET("api/frames/{frameId}/lists/{listId}")
    suspend fun getListDetail(
        @Path("frameId") frameId: String,
        @Path("listId") listId: String,
        @Header("Authorization") authorization: String,
        @Header("Accept") accept: String = "application/json"
    ): Response<SkylightListDetailResponse>
    
    companion object {
        const val BASE_URL = "https://app.ourskylight.com/"
    }
}

/**
 * OpenFoodFacts API Service
 */
interface OpenFoodFactsApiService {
    
    @GET("api/v2/product/{barcode}")
    suspend fun getProduct(
        @Path("barcode") barcode: String
    ): Response<OpenFoodFactsResponse>
    
    companion object {
        const val BASE_URL = "https://world.openfoodfacts.org/"
    }
}
