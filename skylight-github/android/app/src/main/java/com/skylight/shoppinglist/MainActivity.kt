package com.skylight.shoppinglist.ui

import android.Manifest
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.core.content.ContextCompat
import androidx.core.content.PermissionChecker
import com.skylight.shoppinglist.ui.navigation.AppNavigation
import com.skylight.shoppinglist.ui.theme.SkylightTheme
import dagger.hilt.android.AndroidEntryPoint

/**
 * Main Activity with Jetpack Compose UI
 * 
 * Features:
 * - Camera permission handling
 * - Navigation setup
 * - Material 3 theming
 */
@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    
    private var hasCameraPermission by mutableStateOf(false)
    
    private val cameraPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission()
    ) { isGranted ->
        hasCameraPermission = isGranted
    }
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Check camera permission
        checkCameraPermission()
        
        setContent {
            SkylightTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    AppNavigation(
                        hasCameraPermission = hasCameraPermission,
                        onRequestCameraPermission = { requestCameraPermission() }
                    )
                }
            }
        }
    }
    
    private fun checkCameraPermission() {
        hasCameraPermission = ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.CAMERA
        ) == PermissionChecker.PERMISSION_GRANTED
    }
    
    private fun requestCameraPermission() {
        cameraPermissionLauncher.launch(Manifest.permission.CAMERA)
    }
}
