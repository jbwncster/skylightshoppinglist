# Skylight Shopping List - iOS App 📱🛒

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.7+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20iPadOS-lightgrey.svg)

**A native iOS app that scans your fridge/pantry with your camera and syncs shopping lists to Skylight Calendar**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [API](#-api-integration)

</div>

---

## ✨ Features

### 📸 Camera-Powered Scanning
- **Take photos** of your fridge or pantry shelves
- **Automatic detection** using Apple's Vision framework
- **Text recognition** for product labels
- **Smart categorization** (Produce, Dairy, Meat, etc.)
- **Manual editing** of detected items

### 🛒 Shopping List Management
- **Real-time sync** with Skylight API
- **View all lists** from your Skylight calendar
- **Check off items** as you shop
- **Share lists** via iOS share sheet
- **Add items** manually or from pantry

### 📦 Pantry Inventory
- **Store scanned items** with images
- **Organize by category** with smart filters
- **Search functionality** for quick access
- **Track quantities** and expiry dates
- **Mark items** to add to shopping list

### 🔐 Secure Integration
- **Skylight API** authentication
- **Bearer/Basic tokens** support
- **Secure storage** of credentials
- **Frame ID** management

---

## 📱 Screenshots

| Login Screen | Camera Scan | Scan Results | Shopping List |
|-------------|-------------|--------------|---------------|
| 🔐 | 📸 | ✅ | 🛒 |

| Pantry View | Settings |
|-------------|----------|
| 📦 | ⚙️ |

---

## 🚀 Installation

### Prerequisites

- **Xcode 14.0+** installed on macOS
- **iOS 15.0+** device or simulator
- **Apple Developer account** (for device testing)
- **Skylight account** with Frame ID and auth token

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-ios.git
cd skylight-shopping-list-ios
```

### Step 2: Create Xcode Project

1. Open **Xcode**
2. **File → New → Project**
3. Choose **iOS → App**
4. Configure:
   - **Product Name**: SkylightShoppingList
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Bundle Identifier**: com.yourname.SkylightShoppingList

### Step 3: Add Source Files

1. Delete default `ContentView.swift` and app file
2. **Drag all `.swift` files** from the cloned repo into your project
3. Check **"Copy items if needed"**
4. Replace `Info.plist` with the provided one

### Step 4: Configure Assets

1. Open **Assets.xcassets**
2. Create **Color Set** named "AccentColor"
3. Set colors:
   - **Light**: `#d17a47`
   - **Dark**: `#e8a47c`

### Step 5: Build & Run

1. Select your device/simulator
2. Press **⌘ + R**
3. Grant camera permissions when prompted

For detailed setup instructions, see [PROJECT_SETUP.md](PROJECT_SETUP.md)

---

## 📖 Usage

### Getting Your Skylight Credentials

To use this app, you need to capture your Skylight authentication credentials:

1. **Install a Proxy Tool**
   - macOS: [Proxyman](https://proxyman.io/) or [Charles Proxy](https://www.charlesproxy.com/)
   - Follow the [Skylight Auth Guide](https://github.com/mightybandito/Skylight/blob/main/docs/auth.md)

2. **Capture Traffic**
   ```bash
   # Enable SSL proxying for app.ourskylight.com
   # Launch Skylight app and log in
   # Find API request to /api/frames/{frameId}/lists
   ```

3. **Extract Credentials**
   - Copy `Authorization` header (Bearer or Basic token)
   - Note `{frameId}` from API URL path

4. **Login to App**
   - Enter **Frame ID**
   - Select **Auth Type**
   - Paste **Token**
   - Tap **"Connect to Skylight"**

### Using the App

#### 🛒 Shopping List Tab
1. Select a list from dropdown
2. Add items manually or from pantry
3. Check off items as you shop
4. Tap share button to send list

#### 📸 Camera Scan Tab
1. Tap "Take Photo" or "Choose from Library"
2. Capture your fridge/pantry
3. Tap "Scan for Items"
4. Review detected items
5. Edit names, quantities, categories
6. Tap "Add to Pantry"

#### 📦 Pantry Tab
1. View all stored items
2. Filter by category
3. Search for items
4. Swipe right to add to shopping list
5. Swipe left to delete

#### ⚙️ Settings Tab
- View connection status
- Check pantry item count
- Clear all pantry data
- Logout from Skylight

---

## 🔧 API Integration

### Skylight API Endpoints

```swift
// Base URL
https://app.ourskylight.com

// Get all lists
GET /api/frames/{frameId}/lists

// Get list details with items
GET /api/frames/{frameId}/lists/{listId}
```

### Authentication

```swift
// Bearer Token
Authorization: Bearer YOUR_JWT_TOKEN

// Basic Token
Authorization: Basic YOUR_BASE64_TOKEN
```

### JSON:API Format

```json
{
  "data": {
    "type": "list",
    "id": "123",
    "attributes": {
      "label": "Grocery List",
      "kind": "shopping",
      "color": "#FF6B6B"
    },
    "relationships": {
      "list_items": {
        "data": [
          { "type": "list_item", "id": "456" }
        ]
      }
    }
  },
  "included": [
    {
      "type": "list_item",
      "id": "456",
      "attributes": {
        "label": "Milk",
        "status": "pending",
        "position": 0
      }
    }
  ]
}
```

For complete API documentation, visit the [Unofficial Skylight API](https://github.com/mightybandito/Skylight)

---

## 🏗️ Architecture

### Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **Combine** - Reactive state management
- **Vision** - ML-powered image analysis
- **URLSession** - Async/await networking
- **UserDefaults** - Local persistence

### Project Structure

```
SkylightShoppingList/
├── SkylightShoppingListApp.swift   # App entry & state
├── Models.swift                      # Data models
├── SkylightAPIService.swift         # API networking
├── CameraScannerService.swift       # Vision framework
├── ContentView.swift                 # Tab navigation
├── LoginView.swift                   # Auth screen
├── ShoppingListView.swift           # Main list view
├── CameraScanView.swift             # Camera interface
├── CameraPickerView.swift           # UIKit wrapper
├── ScanResultsView.swift            # Review scans
├── PantryView.swift                 # Inventory
├── AdditionalViews.swift            # Settings
└── Info.plist                        # Config
```

### Design Patterns

- **MVVM** - Model-View-ViewModel architecture
- **Repository** - API service layer
- **Singleton** - Scanner service
- **Dependency Injection** - Environment objects

---

## 🔬 Camera Scanning Technical Details

### Vision Framework

The app uses Apple's Vision framework for text and object detection:

```swift
// Text Recognition
VNRecognizeTextRequest
├── Accuracy: .accurate
├── Language Correction: Enabled
└── Recognition Level: Fast

// Food Item Detection
- Keyword matching for common groceries
- Can be enhanced with CoreML models
```

### Improving Detection

For better accuracy, train a custom CoreML model:

1. Collect food/product images
2. Annotate with Create ML
3. Export as `.mlmodel`
4. Replace in `CameraScannerService.swift`

### Current Limitations

- **Basic keyword matching** (no ML model yet)
- **English only** (multi-language support TBD)
- **Manual review required** for all scans

---

## 🚧 Roadmap

- [ ] **CoreML Integration** - Custom food detection model
- [ ] **Barcode Scanning** - UPC/EAN code support
- [ ] **Keychain Storage** - Secure credential storage
- [ ] **iCloud Sync** - Cross-device pantry sync
- [ ] **Widget Support** - Quick access from home screen
- [ ] **Apple Watch App** - Companion app for shopping
- [ ] **Recipe Integration** - Meal planning features
- [ ] **Expiry Notifications** - Alert before items expire
- [ ] **Multi-language** - Internationalization
- [ ] **Dark Mode Polish** - Enhanced dark theme

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Swift API Design Guidelines
- Use SwiftLint for code style
- Add unit tests for new features
- Update documentation

---

## 🐛 Known Issues

### API Limitations
- **Read-only**: Current Skylight API only supports GET requests
- **No POST**: Can't create items via API (local only)
- **Token expiry**: Tokens may expire, requiring re-capture

### Camera Scanning
- **Lighting dependent**: Poor lighting affects detection
- **Label visibility**: Items must have visible labels
- **Generic names**: May detect brand names, not products

---

## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Skylight API**: [github.com/mightybandito/Skylight](https://github.com/mightybandito/Skylight)
- **Apple Vision Framework**: Text and object recognition
- **SwiftUI Community**: Inspiration and support

---

## 📧 Contact & Support

- **Issues**: [GitHub Issues](https://github.com/YOUR_USERNAME/skylight-shopping-list-ios/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR_USERNAME/skylight-shopping-list-ios/discussions)
- **Skylight API Docs**: [mightybandito.github.io/Skylight](https://mightybandito.github.io/Skylight/)

---

## ⚠️ Disclaimer

This is an **unofficial app** and is **not affiliated** with Skylight. Use at your own risk and respect Skylight's Terms of Service. This app is for educational and personal use only.

---

<div align="center">

**Made with ❤️ and SwiftUI**

⭐ Star this repo if you find it helpful!

</div>
