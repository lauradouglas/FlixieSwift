# Contributing to FlixieSwift

Thank you for your interest in contributing to FlixieSwift! This document provides guidelines and information for developers.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/FlixieSwift.git
   cd FlixieSwift
   ```
3. **Open in Xcode**: 
   ```bash
   open FlixieApp/FlixieApp.xcodeproj
   ```
4. **Configure your backend URL** (see XCODE_GUIDE.md)

## Development Workflow

### 1. Create a Branch

Create a new branch for your feature or fix:

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation updates

### 2. Make Your Changes

- Follow Swift naming conventions
- Use SwiftUI best practices
- Keep functions small and focused
- Add comments for complex logic
- Test on both iPhone and iPad simulators

### 3. Code Style

**Swift Style Guide:**
- Use 4 spaces for indentation (Xcode default)
- Keep lines under 120 characters when possible
- Use meaningful variable and function names
- Follow SwiftLint rules (if configured)

**Naming Conventions:**
```swift
// Types: PascalCase
class APIService { }
struct Movie { }

// Variables, functions: camelCase
let userName = "John"
func fetchMovies() { }

// Constants: camelCase
let defaultTimeout = 30.0
static let primaryColor = Color.blue

// Private properties: leading underscore optional
private var _cache: [String: Any]?
```

**SwiftUI Views:**
```swift
struct MyView: View {
    // MARK: - Properties
    @State private var isLoading = false
    
    // MARK: - Body
    var body: some View {
        // View code
    }
    
    // MARK: - Private Methods
    private func loadData() {
        // Implementation
    }
}
```

### 4. Testing

Before submitting:

1. **Build the app**: ⌘B
2. **Run on simulator**: ⌘R
3. **Test on different devices**:
   - iPhone SE (small screen)
   - iPhone 15 Pro (standard)
   - iPad Pro (tablet)
4. **Test in both orientations** (if applicable)
5. **Test dark mode**: Simulator → Appearance → Dark

### 5. Commit Your Changes

Write clear commit messages:

```bash
git add .
git commit -m "Add movie detail view with ratings"
```

**Good commit messages:**
- "Add user authentication flow"
- "Fix crash when loading empty movie list"
- "Improve performance of image loading"
- "Update README with installation steps"

**Avoid:**
- "Fix bug"
- "Update code"
- "Changes"

### 6. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:
- Clear title describing the change
- Description of what changed and why
- Screenshots (if UI changes)
- Link to related issues

## Code Review Process

Your PR will be reviewed for:
- Code quality and style
- Functionality
- Performance impact
- UI/UX considerations
- Documentation updates

Be open to feedback and ready to make changes.

## Project Structure

Understanding the project organization:

```
FlixieApp/FlixieApp/
├── FlixieAppApp.swift       # App entry point
├── ContentView.swift        # Main tab navigation
│
├── Views/                   # UI Components
│   ├── HomeView.swift      # Home screen
│   ├── MoviesView.swift    # Movies list
│   ├── ShowsView.swift     # Shows list
│   ├── GroupView.swift     # Groups
│   └── ProfileView.swift   # User profile
│
├── Models/                  # Data Models
│   └── Models.swift        # User, Movie, Show, Group
│
├── Services/               # Business Logic
│   ├── APIService.swift    # API endpoints
│   └── NetworkManager.swift # HTTP client
│
├── Theme/                  # UI Theme
│   └── ColorTheme.swift   # Color definitions
│
└── Assets.xcassets/       # Images & Assets
```

## Adding New Features

### Adding a New View

1. Create new Swift file in `Views/` folder
2. Import SwiftUI
3. Create struct conforming to `View` protocol
4. Add to navigation in `ContentView.swift`

Example:
```swift
import SwiftUI

struct NewFeatureView: View {
    var body: some View {
        NavigationView {
            Text("New Feature")
                .navigationTitle("Feature")
        }
    }
}

#Preview {
    NewFeatureView()
}
```

### Adding a New Model

1. Add to `Models/Models.swift`
2. Conform to `Codable` and `Identifiable`
3. Use proper `CodingKeys` for API mapping

Example:
```swift
struct Rating: Codable, Identifiable {
    let id: String
    let score: Double
    let userId: String
    let movieId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case score
        case userId
        case movieId
    }
}
```

### Adding a New API Endpoint

1. Add method to `APIService.swift`
2. Handle errors appropriately
3. Use async/await pattern

Example:
```swift
func getRating(id: String) async throws -> Rating {
    guard let url = URL(string: "\(baseURL)/ratings/\(id)") else {
        throw NetworkError.invalidURL
    }
    let response: APIResponse<Rating> = try await NetworkManager.shared.request(url: url)
    guard let rating = response.data else {
        throw NetworkError.noData
    }
    return rating
}
```

## Common Tasks

### Update Color Theme

Edit `Theme/ColorTheme.swift`:
```swift
static let flixiePrimary = Color(hex: "947af1")
```

### Add New Tab

In `ContentView.swift`, add to TabView:
```swift
NewFeatureView()
    .tabItem {
        Label("Feature", systemImage: "star.fill")
    }
    .tag(5)
```

### Loading States

Always handle loading and error states:
```swift
@State private var isLoading = false
@State private var errorMessage: String?

if isLoading {
    ProgressView()
} else if let error = errorMessage {
    Text(error)
        .foregroundColor(.red)
} else {
    // Your content
}
```

## Performance Best Practices

1. **Use LazyVStack/LazyHStack** for long lists
2. **Implement pagination** for large datasets
3. **Cache images** when possible
4. **Use `.task` modifier** for async work
5. **Avoid complex computations in body**

```swift
// Good
ScrollView {
    LazyVStack {
        ForEach(items) { item in
            ItemView(item: item)
        }
    }
}

// Avoid
ScrollView {
    VStack {
        ForEach(items) { item in  // Loads all items at once
            ItemView(item: item)
        }
    }
}
```

## Documentation

When adding features:
- Update README.md if user-facing
- Update API_INTEGRATION.md if backend changes needed
- Add inline comments for complex logic
- Include SwiftUI previews for views

## Accessibility

Make your views accessible:
```swift
Image(systemName: "star")
    .accessibilityLabel("Rating")

Button("Save") { }
    .accessibilityHint("Saves your changes")
```

## Resources

- [Swift Documentation](https://docs.swift.org/swift-book/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)

## Questions?

Open an issue on GitHub for:
- Bug reports
- Feature requests
- Questions about implementation
- Documentation improvements

Thank you for contributing! 🎉
