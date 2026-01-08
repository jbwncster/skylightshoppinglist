# Push Android App to GitHub

## Quick Setup

```bash
# Navigate to Android project
cd /path/to/SkylightShoppingListAndroid

# Initialize Git
git init
git add .
git commit -m "Initial commit: Android app with camera, barcode scanning, and OpenFoodFacts integration"
git branch -M main

# Create GitHub repo at: https://github.com/new
# Name: skylight-shopping-list-android

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/skylight-shopping-list-android.git
git push -u origin main
```

## Repository Setup

### Name
`skylight-shopping-list-android`

### Description
"Android app for Skylight shopping lists with camera scanning, ML Kit barcode reading, and OpenFoodFacts integration"

### Topics (Tags)
Add these topics to your repo:
- `android`
- `kotlin`
- `jetpack-compose`
- `material-design`
- `ml-kit`
- `barcode-scanner`
- `openfoodfacts`
- `camera`
- `shopping-list`
- `skylight`

### Features to Enable

1. **Issues** - ✅ Enable
2. **Wiki** - ✅ Enable (optional)
3. **Discussions** - ✅ Enable (for community)

### Branch Protection

For `main` branch:
1. Settings → Branches → Add rule
2. Pattern: `main`
3. Enable:
   - ✅ Require pull request reviews
   - ✅ Require status checks to pass

## Google Play Store Link (After Publishing)

Add to README badge:

```markdown
[![Get it on Google Play](https://img.shields.io/badge/Get%20it%20on-Google%20Play-green.svg?logo=google-play)](https://play.google.com/store/apps/details?id=com.skylight.shoppinglist)
```

## CI/CD Setup (GitHub Actions)

Create `.github/workflows/android.yml`:

```yaml
name: Android CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '17'
        cache: gradle
    
    - name: Grant execute permission for gradlew
      run: chmod +x gradlew
    
    - name: Build with Gradle
      run: ./gradlew build
    
    - name: Run tests
      run: ./gradlew test
```

## Release Process

1. **Update version** in `app/build.gradle.kts`:
   ```kotlin
   versionCode = 2
   versionName = "1.1.0"
   ```

2. **Tag release**:
   ```bash
   git tag -a v1.1.0 -m "Version 1.1.0"
   git push --tags
   ```

3. **Create GitHub release**:
   - Go to Releases → New release
   - Select tag
   - Add release notes
   - Attach APK/AAB

## README Checklist

- [x] Screenshots
- [x] Installation instructions
- [x] OpenFoodFacts integration docs
- [x] Architecture diagram
- [x] Contributing guidelines
- [x] License

## Star the Dependencies!

Show appreciation for open source:
- ⭐ [Skylight API](https://github.com/mightybandito/Skylight)
- ⭐ [OpenFoodFacts](https://github.com/openfoodfacts)
- ⭐ [ML Kit](https://developers.google.com/ml-kit)

## Community

- Add `CONTRIBUTORS.md`
- Create issue templates
- Add PR template
- Setup discussions

---

Your Android app is ready for GitHub! 🎉
