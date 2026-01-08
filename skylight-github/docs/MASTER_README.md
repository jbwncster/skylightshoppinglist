# Skylight Shopping List - Multi-Platform Apps 📱🪟🍎

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Android](https://img.shields.io/badge/Android-8.0+-green.svg)
![Windows](https://img.shields.io/badge/Windows-11-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**Native apps for iOS, Android, and Windows with camera scanning, barcode reading, and Skylight API integration**

[iOS App](#-ios-app) • [Android App](#-android-app) • [Windows App](#-windows-app) • [Features](#-features)

</div>

---

## 🎯 Project Overview

This is a **complete multi-platform solution** for managing shopping lists with Skylight Calendar integration. Each platform has its own native app with full feature parity.

### 📦 What's Included

- **iOS App** - Swift + SwiftUI with Vision framework
- **Android App** - Kotlin + Jetpack Compose with ML Kit
- **Windows App** - C# + .NET MAUI for Windows Store

All three apps share:
- ✅ Camera-based pantry scanning
- ✅ Barcode scanning with OpenFoodFacts
- ✅ Skylight Calendar API integration
- ✅ Local pantry management
- ✅ Offline support

---

## ✨ Features

### 📸 Camera Scanning
- Take photos of your fridge/pantry
- AI-powered item detection
- Text recognition on product labels
- Manual editing and categorization

### 🏷️ Barcode Scanning + OpenFoodFacts
- Scan any UPC/EAN barcode
- **750,000+ products** in database
- Instant nutrition facts
- Ingredients and allergens
- Brand and category info
- Product images

### 🛒 Skylight Integration
- Real-time API sync
- View all shopping lists
- Check off items while shopping
- Share lists
- Multi-frame support

### 📦 Smart Pantry
- Store items with photos
- Nutrition information
- Expiry date tracking
- Category organization
- Search and filter
- Mark items for shopping list

### 🎨 Platform-Native Design
- **iOS**: UIKit/SwiftUI with iOS Design Language
- **Android**: Material 3 Design with dynamic theming
- **Windows**: Fluent Design System with Acrylic effects

---

## 📱 iOS App

### Tech Stack
- **Swift 5.7+**
- **SwiftUI** - Modern declarative UI
- **Vision Framework** - ML-powered scanning
- **Combine** - Reactive programming
- **UserDefaults** - Local storage

### Repository
```bash
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-ios.git
```

### Quick Start
1. Open Xcode 14+
2. Drag Swift files into new project
3. Configure signing
4. Build & Run

### 📖 Full Documentation
See [iOS Project README](../SkylightShoppingList/README.md)

---

## 🤖 Android App

### Tech Stack
- **Kotlin 1.9+**
- **Jetpack Compose** - Modern UI toolkit
- **ML Kit** - Text & barcode recognition
- **CameraX** - Camera API
- **Retrofit** - REST client
- **Hilt** - Dependency injection
- **DataStore** - Local persistence

### Repository
```bash
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-android.git
```

### Quick Start
1. Open Android Studio
2. File → Open
3. Select project folder
4. Wait for Gradle sync
5. Run on device/emulator

### 📖 Full Documentation
See [Android Project README](../SkylightShoppingListAndroid/README.md)

---

## 🪟 Windows App

### Tech Stack
- **.NET 8 + MAUI**
- **C# 12** - Latest language features
- **WinUI 3** - Modern Windows UI
- **Windows.Media.Capture** - Camera API
- **ZXing.Net.Maui** - Barcode scanning
- **SQLite** - Local database

### Repository
```bash
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-windows.git
```

### Quick Start
1. Open Visual Studio 2022
2. Install .NET MAUI workload
3. Open solution file
4. Set Windows Machine as startup
5. Press F5

### 📖 Full Documentation
See [Windows Project README](../SkylightShoppingListWindows/README.md)

---

## 🔗 OpenFoodFacts Integration

All three apps use the **OpenFoodFacts API** for barcode scanning:

### About OpenFoodFacts
- **Open database** of food products
- **750,000+ products** worldwide
- **Nutrition information** for each product
- **Ingredients** and allergens
- **Community-driven** (like Wikipedia for food)
- **Free and open source**

### API Usage

```http
GET https://world.openfoodfacts.org/api/v2/product/{barcode}
```

**Example Response:**
```json
{
  "product": {
    "product_name": "Nutella",
    "brands": "Ferrero",
    "categories": "Spreads",
    "nutriments": {
      "energy-kcal_100g": 539,
      "proteins_100g": 6.3,
      "fat_100g": 30.9,
      "carbohydrates_100g": 57.5
    },
    "ingredients_text": "Sugar, palm oil, hazelnuts (13%)...",
    "image_url": "https://..."
  }
}
```

### Supported Barcodes
- UPC-A & UPC-E
- EAN-8 & EAN-13
- Code 128
- QR Code
- And more...

### Why OpenFoodFacts?
- ✅ **Free** - No API keys required
- ✅ **No rate limits** - Unlimited requests
- ✅ **Global** - Products from all countries
- ✅ **Open source** - Contribute back
- ✅ **Privacy-friendly** - No tracking

---

## 🚀 Getting Started

### Prerequisites

**All Platforms:**
- Skylight account
- Frame ID and auth token (see below)

**Platform-Specific:**
- **iOS**: Xcode 14+, macOS, iOS device/simulator
- **Android**: Android Studio, JDK 17, Android 8.0+ device
- **Windows**: Visual Studio 2022, .NET 8 SDK, Windows 11

### Getting Skylight Credentials

1. **Install Proxy Tool**
   - macOS: [Proxyman](https://proxyman.io/) or [Charles Proxy](https://www.charlesproxy.com/)
   - Windows: [Fiddler](https://www.telerik.com/fiddler) or Charles Proxy

2. **Capture Traffic**
   - Enable SSL proxying for `app.ourskylight.com`
   - Launch Skylight app
   - Log in
   - Find API request to `/api/frames/{frameId}/lists`

3. **Extract Credentials**
   - Copy `Authorization` header (Bearer or Basic token)
   - Note `frameId` from URL path

4. **Enter in App**
   - Launch shopping list app
   - Enter Frame ID
   - Select auth type
   - Paste token
   - Connect

### Detailed Auth Guide
See [Skylight API Auth Documentation](https://github.com/mightybandito/Skylight/blob/main/docs/auth.md)

---

## 📊 Feature Comparison

| Feature | iOS | Android | Windows |
|---------|-----|---------|---------|
| Camera Scanning | ✅ Vision | ✅ ML Kit | ✅ WinRT |
| Barcode Scanning | ✅ Vision | ✅ ML Kit | ✅ ZXing |
| OpenFoodFacts | ✅ | ✅ | ✅ |
| Skylight Sync | ✅ | ✅ | ✅ |
| Offline Mode | ✅ | ✅ | ✅ |
| Dark Mode | ✅ | ✅ | ✅ |
| Share Lists | ✅ | ✅ | ✅ |
| Widgets | 🔜 | 🔜 | 🔜 |
| Watch App | 🔜 iOS | 🔜 Wear | ❌ |

---

## 🏗️ Architecture

All three apps follow **MVVM pattern**:

```
┌─────────────────┐
│      View       │  (UI Layer)
│  SwiftUI/Compose/XAML
└────────┬────────┘
         │
┌────────▼────────┐
│   ViewModel     │  (Presentation Logic)
│  State Management
└────────┬────────┘
         │
┌────────▼────────┐
│     Model       │  (Data Layer)
│  API + Storage
└─────────────────┘
```

### Shared Concepts
- **Repository Pattern** - Data abstraction
- **Dependency Injection** - Testability
- **Async/Await** - Modern concurrency
- **State Management** - Reactive updates

---

## 📦 Distribution

### iOS - App Store
1. Build in Xcode
2. Archive for distribution
3. Upload to App Store Connect
4. Submit for review

**Cost**: $99/year developer account

### Android - Google Play
1. Build signed APK/AAB
2. Create Play Console listing
3. Upload bundle
4. Submit for review

**Cost**: $25 one-time fee

### Windows - Microsoft Store
1. Build MSIX package
2. Create Partner Center listing
3. Upload MSIX
4. Submit for certification

**Cost**: $19 individual / $99 company

---

## 🤝 Contributing

Contributions welcome to all three projects!

### What to Contribute
- 🐛 Bug fixes
- ✨ New features
- 📝 Documentation improvements
- 🌍 Translations
- 🎨 UI enhancements

### How to Contribute
1. Fork the repository
2. Create feature branch
3. Make changes
4. Test thoroughly
5. Submit pull request

See individual project CONTRIBUTING.md files for details.

---

## 🐛 Known Limitations

### API Restrictions
- **Read-only**: Skylight API only supports GET requests currently
- **No POST**: Can't create items via API (local only)
- **Token expiry**: Tokens need periodic re-capture

### Camera Scanning
- **Lighting dependent**: Poor lighting reduces accuracy
- **Label visibility**: Items need visible product labels
- **Language**: Currently English only

### OpenFoodFacts
- **Coverage**: Not all products are in database
- **Accuracy**: Community-contributed data may have errors
- **Regions**: Better coverage in Europe/North America

---

## 🚧 Roadmap

### Planned Features
- [ ] **Offline sync** - Queue changes for later
- [ ] **Recipe integration** - Meal planning
- [ ] **Price tracking** - Compare store prices
- [ ] **Expiry alerts** - Push notifications
- [ ] **Voice commands** - Siri/Google/Cortana
- [ ] **Widgets** - Home screen quick access
- [ ] **Watch apps** - Wearable support
- [ ] **Multi-language** - Internationalization

### Platform-Specific
- [ ] **iOS**: SharePlay, Live Activities
- [ ] **Android**: Wear OS, Material You
- [ ] **Windows**: Xbox, Live Tiles

---

## 📝 License

All three projects are licensed under the **MIT License**.

See LICENSE file in each project for details.

---

## 🙏 Acknowledgments

### APIs & Services
- **Skylight API** - [github.com/mightybandito/Skylight](https://github.com/mightybandito/Skylight)
- **OpenFoodFacts** - [openfoodfacts.org](https://world.openfoodfacts.org/)

### Frameworks & Tools
- **Apple** - SwiftUI, Vision, Core ML
- **Google** - Jetpack Compose, ML Kit, CameraX
- **Microsoft** - .NET MAUI, WinUI 3
- **ZXing** - Barcode scanning library

### Community
- All contributors and testers
- Skylight community
- OpenFoodFacts contributors

---

## 📧 Support

- **iOS Issues**: [iOS GitHub Issues](https://github.com/YOUR_USERNAME/skylight-shopping-list-ios/issues)
- **Android Issues**: [Android GitHub Issues](https://github.com/YOUR_USERNAME/skylight-shopping-list-android/issues)
- **Windows Issues**: [Windows GitHub Issues](https://github.com/YOUR_USERNAME/skylight-shopping-list-windows/issues)
- **General Discussion**: [GitHub Discussions](https://github.com/YOUR_USERNAME/skylight-shopping-list/discussions)

---

## ⚠️ Disclaimer

These are **unofficial apps** and are **not affiliated** with Skylight or OpenFoodFacts. 

- Use at your own risk
- Respect Skylight's Terms of Service
- Respect OpenFoodFacts' Terms of Use
- For educational and personal use only

---

<div align="center">

**Made with ❤️ for iOS, Android, and Windows**

⭐ Star all three repos if you find them helpful!

[iOS Repo](https://github.com/YOUR_USERNAME/skylight-shopping-list-ios) • 
[Android Repo](https://github.com/YOUR_USERNAME/skylight-shopping-list-android) • 
[Windows Repo](https://github.com/YOUR_USERNAME/skylight-shopping-list-windows)

</div>
