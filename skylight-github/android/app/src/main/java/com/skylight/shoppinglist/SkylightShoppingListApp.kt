package com.skylight.shoppinglist

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

/**
 * Skylight Shopping List - Android Application
 * 
 * Features:
 * - Camera scanning with ML Kit
 * - Barcode scanning with OpenFoodFacts API
 * - Skylight API integration
 * - Material 3 Design
 */
@HiltAndroidApp
class SkylightShoppingListApp : Application() {
    
    override fun onCreate() {
        super.onCreate()
        
        // Initialize any required services
        initializeApp()
    }
    
    private fun initializeApp() {
        // Setup logging, crash reporting, etc.
    }
}
