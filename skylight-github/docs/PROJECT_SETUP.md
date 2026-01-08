# Skylight Shopping List - Complete iOS Project

## Project Overview

This is a complete native iOS application built with Swift and SwiftUI that integrates with the Skylight API to provide:

1. **Camera-based pantry scanning** using Apple's Vision framework
2. **Shopping list management** synced with your Skylight calendar
3. **Pantry inventory** with automatic item detection
4. **Cross-platform compatibility** (iOS, iPadOS)

## What's Included

### Complete Swift Source Files

1. **SkylightShoppingListApp.swift** - Main app entry point and state management
2. **Models.swift** - All data models (JSON:API compliant)
3. **SkylightAPIService.swift** - Network layer with async/await
4. **CameraScannerService.swift** - Vision framework integration for scanning
5. **ContentView.swift** - Tab-based navigation
6. **LoginView.swift** - Authentication screen
7. **ShoppingListView.swift** - Main shopping list with Skylight sync
8. **CameraScanView.swift** - Camera interface for scanning
9. **CameraPickerView.swift** - UIKit camera wrapper
10. **ScanResultsView.swift** - Review and edit scanned items
11. **PantryView.swift** - Manage pantry inventory
12. **AdditionalViews.swift** - Settings and helper views
13. **Info.plist** - App configuration with camera permissions

## How to Create the Xcode Project

### Step 1: Create New Project in Xcode

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Click "Next"

### Step 2: Configure Project Settings

- **Product Name**: SkylightShoppingList
- **Team**: Your development team
- **Organization Identifier**: com.yourname (e.g., com.jake)
- **Bundle Identifier**: com.yourname.SkylightShoppingList
- **Interface**: SwiftUI
- **Language**: Swift
- **Use Core Data**: No
- **Include Tests**: Optional

### Step 3: Add Source Files

1. Delete the default `ContentView.swift` and `SkylightShoppingListApp.swift`
2. Drag all `.swift` files from this project into your Xcode project
3. When prompted, check "Copy items if needed"
4. Make sure "Add to targets" is checked for your app target

### Step 4: Configure Info.plist

1. Replace the default `Info.plist` with the provided one, OR
2. Add these keys manually to your existing Info.plist:
   - NSCameraUsageDescription
   - NSPhotoLibraryUsageDescription  
   - NSPhotoLibraryAddUsageDescription

### Step 5: Add Color Asset

1. Open Assets.xcassets
2. Click + → Color Set
3. Name it "AccentColor"
4. Set colors:
   - Light mode: #d17a47
   - Dark mode: #e8a47c

### Step 6: Add Fonts (Optional)

To use DM Serif Display font:

1. Download from [Google Fonts](https://fonts.google.com/specimen/DM+Serif+Display)
2. Add .ttf files to project
3. Add font names to Info.plist under "Fonts provided by application"

OR the app will fall back to system fonts.

### Step 7: Set Deployment Target

1. Select project in navigator
2. Under "Deployment Info"
3. Set "Minimum Deployments" to iOS 15.0 or higher

### Step 8: Configure Signing

1. Select your target
2. Go to "Signing & Capabilities"
3. Enable "Automatically manage signing"
4. Select your team

### Step 9: Build and Run

1. Select your device or simulator
2. Press ⌘ + R to build and run
3. Grant camera and photo library permissions when prompted

## Using the App

### Initial Setup

1. **Get Skylight Credentials**
   - Follow: https://github.com/mightybandito/Skylight/blob/main/docs/auth.md
   - Use Proxyman or Charles Proxy to capture traffic
   - Copy your Authorization header
   - Note your Frame ID from API URLs

2. **Login to App**
   - Enter Frame ID
   - Select auth type (Bearer or Basic)
   - Paste token
   - Tap "Connect to Skylight"

### Features Overview

**Tab 1: Shopping List**
- View Skylight shopping lists
- Check off items
- Add items from pantry
- Share lists

**Tab 2: Camera Scan**
- Take photo of fridge/pantry
- Automatic item detection
- Review and edit detected items
- Add to pantry

**Tab 3: Pantry**
- View all pantry items
- Filter by category
- Search items
- Mark items for shopping list
- Manage inventory

**Tab 4: Settings**
- View connection status
- Manage pantry data
- Logout

## Technical Details

### Architecture

- **Pattern**: MVVM with Combine
- **State Management**: @StateObject, @EnvironmentObject
- **Networking**: Async/await with URLSession
- **Storage**: UserDefaults (can be upgraded to Keychain)
- **ML**: Vision framework for text/object recognition

### Dependencies

**None!** This is a pure Swift project with no external dependencies.

Uses only Apple frameworks:
- SwiftUI
- Combine
- Vision
- UIKit (for camera)
- Foundation

### API Integration

Connects to:
```
https://app.ourskylight.com/api/frames/{frameId}/lists
```

Follows JSON:API specification for data format.

### Camera Scanning

Uses `VNRecognizeTextRequest` for:
- Reading product labels
- Detecting text in images
- Filtering food-related keywords

Can be enhanced with custom CoreML models.

## For Android/Windows

This is an **iOS-only** Swift project. For other platforms:

### Android Version
Would need to be built with:
- Kotlin + Jetpack Compose
- CameraX for camera
- ML Kit for text recognition
- Retrofit for API calls

### Windows Version
Would need to be built with:
- .NET MAUI or WinUI 3
- Windows.Media.Capture for camera
- Azure Computer Vision or similar
- HttpClient for API

### Cross-Platform Alternative
Consider using:
- Flutter (Dart)
- React Native (JavaScript)
- .NET MAUI (C#)

For a web-based PWA that works everywhere, see the HTML version included separately.

## Production Considerations

Before publishing to App Store:

1. **Security**
   - Move credentials from UserDefaults to Keychain
   - Implement certificate pinning
   - Add token refresh logic

2. **Privacy**
   - Add privacy policy
   - Implement data deletion
   - Add opt-out mechanisms

3. **Performance**
   - Add image compression
   - Implement caching
   - Optimize API calls

4. **UX**
   - Add loading states
   - Improve error handling
   - Add haptic feedback
   - Implement dark mode refinements

5. **ML**
   - Train custom CoreML model
   - Add barcode scanning
   - Improve detection accuracy

## Support

- **Skylight API Docs**: https://github.com/mightybandito/Skylight
- **Apple Developer**: https://developer.apple.com/documentation/
- **Vision Framework**: https://developer.apple.com/documentation/vision

## License

MIT License - Free to use and modify

---

**Ready to use!** Just follow the steps above to create your Xcode project and start scanning your pantry! 📸🛒
