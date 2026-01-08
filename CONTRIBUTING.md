# Contributing to Skylight Shopping List

First off, thank you for considering contributing to Skylight Shopping List! It's people like you that make this app better for everyone.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Respect differing viewpoints

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues. When creating a bug report, include:

- **Clear title** describing the issue
- **Steps to reproduce** the behavior
- **Expected behavior** vs actual behavior
- **Screenshots** if applicable
- **Device/OS version** (e.g., iPhone 14 Pro, iOS 16.5)
- **App version**

**Example:**
```
Title: Camera crashes when scanning in low light

Steps:
1. Open Camera Scan tab
2. Take photo in dimly lit room
3. Tap "Scan for Items"
4. App crashes

Expected: Image should be scanned
Actual: App crashes to home screen

Device: iPhone 13, iOS 16.2
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Include:

- **Clear title** describing the enhancement
- **Detailed description** of the feature
- **Use cases** - why is this useful?
- **Mockups** or examples if applicable

### Pull Requests

1. **Fork** the repo and create your branch from `main`
2. **Test** your changes thoroughly
3. **Update documentation** if needed
4. **Follow code style** (SwiftLint)
5. **Write clear commit messages**

## Development Setup

### Prerequisites

```bash
# Install Xcode 14.0+
# Install SwiftLint (optional but recommended)
brew install swiftlint
```

### Local Development

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/skylight-shopping-list-ios.git
cd skylight-shopping-list-ios

# Create feature branch
git checkout -b feature/your-feature-name

# Make changes and commit
git add .
git commit -m "Add your feature"

# Push to your fork
git push origin feature/your-feature-name
```

## Code Style Guidelines

### Swift Style

Follow the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/):

```swift
// Good
func fetchShoppingList(for frameId: String) async throws -> [ShoppingList]

// Bad
func getList(id: String) -> [ShoppingList]?
```

### Naming Conventions

- **Types**: PascalCase (`ShoppingList`, `PantryItem`)
- **Functions**: camelCase (`loadItems()`, `scanImage()`)
- **Constants**: camelCase (`maxRetries`, `defaultTimeout`)
- **Private properties**: Start with underscore optional

### SwiftUI Best Practices

```swift
// Extract views for clarity
struct ItemRow: View {
    let item: PantryItem
    var body: some View {
        // ...
    }
}

// Use @State for view-local state
@State private var isLoading = false

// Use @EnvironmentObject for app-wide state
@EnvironmentObject var appState: AppState
```

### Comments

```swift
// MARK: - Section Headers for organization

/// Documentation comments for public APIs
/// - Parameter frameId: The Skylight frame identifier
/// - Returns: Array of shopping lists
func fetchLists(frameId: String) async throws -> [ShoppingList]
```

## Testing Guidelines

### Unit Tests

Add tests for:
- API service methods
- Data model parsing
- Business logic

```swift
func testListDecoding() throws {
    let json = """
    {
        "data": { "type": "list", "id": "123", ... }
    }
    """
    let list = try JSONDecoder().decode(SkylightListsResponse.self, from: json.data(using: .utf8)!)
    XCTAssertEqual(list.data.first?.id, "123")
}
```

### UI Tests

Test critical user flows:
- Login process
- Camera scanning
- Adding items to list

## Documentation

### Code Documentation

```swift
/// Scans an image for food items using Vision framework
/// 
/// This method uses VNRecognizeTextRequest to detect text on product labels
/// and filters for common food-related keywords.
///
/// - Parameter image: The UIImage to scan
/// - Returns: ScanResult containing detected items and confidence scores
/// - Throws: ScanError if image processing fails
func scanImage(_ image: UIImage) async throws -> ScanResult
```

### README Updates

When adding features:
1. Update feature list
2. Add usage instructions
3. Update screenshots if UI changed
4. Add to roadmap if incomplete

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Format
<type>(<scope>): <subject>

# Types
feat:     New feature
fix:      Bug fix
docs:     Documentation only
style:    Code style (formatting, etc)
refactor: Code restructuring
test:     Adding tests
chore:    Maintenance

# Examples
feat(camera): Add barcode scanning support
fix(api): Handle token expiration gracefully
docs(readme): Update installation instructions
```

## Branch Naming

```bash
feature/camera-barcode-scan    # New features
fix/login-crash-ios16          # Bug fixes
docs/api-documentation         # Documentation
refactor/scanner-service       # Code improvements
```

## Pull Request Process

1. **Update README** with new features/changes
2. **Add/update tests** for your changes
3. **Ensure CI passes** (when set up)
4. **Request review** from maintainers
5. **Address feedback** promptly

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How was this tested?

## Screenshots
If applicable

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
```

## Adding New Features

### Large Features

For significant features (e.g., barcode scanning):

1. **Create an issue** first to discuss
2. **Get feedback** on approach
3. **Break into smaller PRs** if possible
4. **Document thoroughly**

### Feature Branch Workflow

```bash
# Stay updated with main
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/barcode-scanner

# Make changes incrementally
git commit -m "feat(scanner): Add barcode detection"
git commit -m "feat(scanner): Add UPC database lookup"
git commit -m "docs(scanner): Document barcode feature"

# Keep branch updated
git checkout main
git pull origin main
git checkout feature/barcode-scanner
git rebase main

# Push when ready
git push origin feature/barcode-scanner
```

## CoreML Model Contributions

If contributing ML models:

1. **Document training process**
2. **Include dataset info** (license permitting)
3. **Provide accuracy metrics**
4. **Test on various devices**
5. **Check model size** (<50MB preferred)

```swift
// Include model metadata
/*
Model: FoodDetector.mlmodel
Training: Create ML 4.0
Dataset: Food-101 (subset)
Accuracy: 87% on test set
Size: 23.4 MB
License: MIT
*/
```

## API Changes

When modifying Skylight API integration:

1. **Document endpoints** used
2. **Handle errors** gracefully
3. **Add retry logic** where appropriate
4. **Test with real API** (not just mocks)
5. **Update API documentation**

## Questions?

- **GitHub Discussions**: For general questions
- **GitHub Issues**: For bugs and features
- **Code Comments**: For code-specific questions

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in commits

Thank you for making Skylight Shopping List better! 🎉
