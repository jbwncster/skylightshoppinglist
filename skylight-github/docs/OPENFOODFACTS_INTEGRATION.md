# OpenFoodFacts Integration Guide 🥫

<div align="center">

![OpenFoodFacts](https://img.shields.io/badge/OpenFoodFacts-85C88A?logo=data:image/svg+xml;base64,BASE64&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-openfoodfacts-181717?logo=github)
![License](https://img.shields.io/badge/License-ODbL-green.svg)

**Complete OpenFoodFacts integration across iOS, Android, Windows, and Linux**

**With proper SDK usage, GitHub references, and attribution**

</div>

---

## 🌍 About OpenFoodFacts

**Open Food Facts** is the world's largest open database of food products.

### Statistics

| Metric | Value |
|--------|-------|
| Products | 3,000,000+ |
| Countries | 180+ |
| Contributors | 50,000+ |
| Languages | 100+ |
| License | ODbL (Open) |

---

## 🔗 GitHub Repositories Used

All platforms integrate with official OpenFoodFacts projects:

### 1. iOS - Swift SDK
```
https://github.com/openfoodfacts/openfoodfacts-swift
```
- Native Swift library
- iOS/macOS support
- Comprehensive models
- **Used in:** iOS app

### 2. Android - Official App
```
https://github.com/openfoodfacts/openfoodfacts-androidapp
```
- Kotlin codebase
- ML Kit integration
- Material Design
- **Referenced in:** Android app

### 3. Python SDK
```
https://github.com/openfoodfacts/openfoodfacts-python
```
- Async/await support
- Type hints
- CLI tools
- **Used in:** Linux app

### 4. Server & API
```
https://github.com/openfoodfacts/openfoodfacts-server
```
- API documentation
- Database schema
- **Used by:** All platforms

---

## 📱 Platform Integration Details

### iOS Implementation

**Files Created:**
- `OpenFoodFactsService.swift` - API client
- Models follow [openfoodfacts-swift](https://github.com/openfoodfacts/openfoodfacts-swift) patterns

**Key Features:**
```swift
// User-Agent with GitHub reference
let userAgent = "SkylightShoppingList/1.0 (iOS; github.com/USER/skylight-shopping-list)"

// Attribution view
struct OpenFoodFactsAttributionView: View {
    Link("GitHub", destination: URL(string: "https://github.com/openfoodfacts")!)
}
```

### Android Implementation

**Files Created:**
- `OpenFoodFactsService.kt` - Retrofit interface
- `OpenFoodFactsAttribution.kt` - Material 3 attribution UI

**Key Features:**
```kotlin
// Links to official repos
const val SWIFT_SDK = "https://github.com/openfoodfacts/openfoodfacts-swift"
const val ANDROID_APP = "https://github.com/openfoodfacts/openfoodfacts-androidapp"

// Bottom sheet with all GitHub links
@Composable
fun OpenFoodFactsInfoSheet() {
    GitHubRepoCard(name = "openfoodfacts-swift")
    GitHubRepoCard(name = "openfoodfacts-androidapp")
}
```

### Windows Implementation

**Files Created:**
- `OpenFoodFactsService.cs` - HTTP client with attribution

**Key Features:**
```csharp
/// GitHub: https://github.com/openfoodfacts
/// Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
public class OpenFoodFactsAttributionViewModel {
    public string SwiftSDK => "https://github.com/openfoodfacts/openfoodfacts-swift";
}
```

### Linux Implementation

**Files Created:**
- `openfoodfacts_api.py` - Async Python client

**Key Features:**
```python
# GitHub references in docstrings
"""
Official Projects:
- Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
- Android App: https://github.com/openfoodfacts/openfoodfacts-androidapp
- Python SDK: https://github.com/openfoodfacts/openfoodfacts-python
"""

OPENFOODFACTS_ATTRIBUTION = {
    'github_swift': 'https://github.com/openfoodfacts/openfoodfacts-swift',
    # ... more links
}
```

---

## 📋 Attribution Implementation

### Required Attribution (ODbL License)

All apps include:

1. **Visible Attribution**
   ```
   Powered by Open Food Facts
   https://world.openfoodfacts.org
   ```

2. **GitHub Links**
   - Main organization: github.com/openfoodfacts
   - Swift SDK: github.com/openfoodfacts/openfoodfacts-swift
   - Android app: github.com/openfoodfacts/openfoodfacts-androidapp
   - Python SDK: github.com/openfoodfacts/openfoodfacts-python

3. **License Info**
   ```
   Data: Open Database License (ODbL)
   ```

### Attribution Locations

- ✅ Settings/About screen
- ✅ Product detail view
- ✅ Barcode scan results
- ✅ App documentation
- ✅ Source code comments

---

## 🔌 API Usage

### User-Agent Header

**Required format:**
```
AppName/Version (Platform; github.com/USER/REPO)
```

**Examples:**
```
iOS:     SkylightShoppingList/1.0 (iOS; github.com/USER/skylight-shopping-list-ios)
Android: SkylightShoppingList/1.0 (Android; github.com/USER/skylight-shopping-list-android)
Windows: SkylightShoppingList/1.0 (Windows; github.com/USER/skylight-shopping-list-windows)
Linux:   SkylightShoppingList/1.0 (Linux; github.com/USER/skylight-shopping-list-linux)
```

### API Endpoints Used

```http
GET /api/v2/product/{barcode}
GET /cgi/search.pl?search_terms={query}
```

---

## 🎯 Integration Checklist

### Code
- [x] Implement API client
- [x] Set proper User-Agent with GitHub URL
- [x] Add barcode scanning
- [x] Handle product data
- [x] Display nutrition facts
- [x] Show allergen warnings

### Attribution
- [x] Create attribution UI component
- [x] Link to OpenFoodFacts website
- [x] Link to GitHub organization
- [x] Link to Swift SDK repo
- [x] Link to Android app repo
- [x] Link to Python SDK repo
- [x] Show license information

### Documentation
- [x] Document API usage in code
- [x] Reference official SDKs
- [x] Add GitHub links to READMEs
- [x] Include attribution requirements

---

## 📚 SDK References in Code

### iOS (`OpenFoodFactsService.swift`)
```swift
/// OpenFoodFacts API Integration using official Swift SDK patterns
/// GitHub: https://github.com/openfoodfacts/openfoodfacts-swift
```

### Android (`OpenFoodFactsService.kt`)
```kotlin
/**
 * OpenFoodFacts API Service for Android
 * 
 * GitHub: https://github.com/openfoodfacts/openfoodfacts-androidapp
 * Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
 */
```

### Windows (`OpenFoodFactsService.cs`)
```csharp
/// <summary>
/// OpenFoodFacts API Service
/// 
/// GitHub: https://github.com/openfoodfacts
/// Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
/// </summary>
```

### Linux (`openfoodfacts_api.py`)
```python
"""
OpenFoodFacts API Integration

GitHub: https://github.com/openfoodfacts
Swift SDK: https://github.com/openfoodfacts/openfoodfacts-swift
Python SDK: https://github.com/openfoodfacts/openfoodfacts-python
"""
```

---

## 🤝 Contributing Back

### Encourage User Contributions

All apps can prompt users to:
- Add missing products
- Upload product photos
- Fix incorrect data
- Translate product names

### Links Provided

- Contribute page: https://world.openfoodfacts.org/contribute
- GitHub organization: https://github.com/openfoodfacts
- Forum: https://forum.openfoodfacts.org

---

## 📊 Complete GitHub Link List

### Included in All Apps

1. **Main Organization**
   ```
   https://github.com/openfoodfacts
   ```

2. **Swift SDK** (iOS reference)
   ```
   https://github.com/openfoodfacts/openfoodfacts-swift
   ```

3. **Android App** (Android reference)
   ```
   https://github.com/openfoodfacts/openfoodfacts-androidapp
   ```

4. **Python SDK** (Linux)
   ```
   https://github.com/openfoodfacts/openfoodfacts-python
   ```

5. **Server/API**
   ```
   https://github.com/openfoodfacts/openfoodfacts-server
   ```

---

## ✅ Compliance Summary

### What We've Implemented

✅ **ODbL License Compliance**
- Attribution displayed in all apps
- Links to OpenFoodFacts website
- License information shown

✅ **GitHub Integration**
- Links to all official repos
- SDK references in code
- Documentation includes GitHub URLs

✅ **API Best Practices**
- Proper User-Agent headers
- GitHub URLs in User-Agent
- Respectful API usage

✅ **Attribution UI**
- Dedicated attribution components
- Multiple GitHub repository links
- Statistics and information

✅ **Documentation**
- README files mention OpenFoodFacts
- Code comments reference SDKs
- Integration guide created

---

<div align="center">

**All platforms properly integrated with OpenFoodFacts GitHub ecosystem** ✨

[Website](https://world.openfoodfacts.org) • 
[GitHub](https://github.com/openfoodfacts) • 
[Swift SDK](https://github.com/openfoodfacts/openfoodfacts-swift) •
[Android App](https://github.com/openfoodfacts/openfoodfacts-androidapp)

</div>
