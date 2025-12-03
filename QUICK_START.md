# Quick Reference Guide

## 🚀 Quick Start

### For macOS with Xcode:
```bash
# Open the project in Xcode
open FlixieApp/FlixieApp.xcodeproj

# Or from Xcode:
# File → Open → Select FlixieApp.xcodeproj
```

### First Run Setup:
1. Edit Scheme (⌘<) → Run → Arguments → Environment Variables
2. Add: `FLIXIE_API_URL = http://localhost:3000/api`
3. Select iPhone simulator from device selector
4. Press ⌘R to build and run

---

## 📱 App Structure

### Main Views:
- **Home** - Featured content dashboard
- **Movies** - Browse and search movies
- **Shows** - Browse and search TV shows
- **Groups** - Create and join watch groups
- **Profile** - User account management

### Color Theme:
All defined in `Theme/ColorTheme.swift`:
- Primary: #947af1 (Purple)
- Secondary: #08a391 (Teal)  
- Tertiary: #f1a77a (Peach)
- Background: #172b4d (Dark Blue)

---

## 🔌 Backend Integration

### Required Endpoints:

**Users:**
- `GET /api/users/:id` - Profile
- `PATCH /api/users/:id` - Update profile

**Movies:**
- `GET /api/movies?page=1&pageSize=20` - List
- `GET /api/movies/:id` - Details
- `GET /api/movies/search?q=query` - Search

**Shows:**
- `GET /api/shows?page=1&pageSize=20` - List
- `GET /api/shows/:id` - Details
- `GET /api/shows/search?q=query` - Search

**Groups:**
- `GET /api/groups?page=1&pageSize=20` - List
- `GET /api/groups/:id` - Details
- `POST /api/groups` - Create
- `POST /api/groups/:id/join` - Join group

### Response Format:
```json
{
  "success": true,
  "data": { /* your data */ }
}
```

Paginated:
```json
{
  "items": [...],
  "total": 100,
  "page": 1,
  "pageSize": 20,
  "hasMore": true
}
```

---

## ⌨️ Essential Xcode Shortcuts

### Running:
- `⌘R` - Run app
- `⌘B` - Build
- `⌘.` - Stop
- `⌘⇧K` - Clean

### Editing:
- `⌘/` - Comment
- `⌘⇧O` - Quick open
- `⌘⇧J` - Show in navigator

### Views:
- `⌘0` - Toggle navigator
- `⌘⇧Y` - Toggle console
- `⌘⌥↩` - Toggle canvas

---

## 🛠️ Common Tasks

### Add New View:
```swift
import SwiftUI

struct NewView: View {
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    NewView()
}
```

### Add to Navigation:
Edit `ContentView.swift`, add to TabView:
```swift
NewView()
    .tabItem {
        Label("Title", systemImage: "icon")
    }
    .tag(5)
```

### Add API Call:
In `APIService.swift`:
```swift
func getData() async throws -> SomeModel {
    guard let url = URL(string: "\(baseURL)/endpoint") else {
        throw NetworkError.invalidURL
    }
    let response: APIResponse<SomeModel> = 
        try await NetworkManager.shared.request(url: url)
    guard let data = response.data else {
        throw NetworkError.noData
    }
    return data
}
```

### Add Model:
In `Models/Models.swift`:
```swift
struct MyModel: Codable, Identifiable {
    let id: String
    let name: String
}
```

---

## 🐛 Troubleshooting

### Can't connect to backend?
- ✅ Backend running?
- ✅ Correct URL in environment variable?
- ✅ Using `localhost` for simulator, IP for device?

### Build errors?
```bash
# Clean build
⌘⇧K

# Or delete derived data:
rm -rf ~/Library/Developer/Xcode/DerivedData/FlixieApp-*
```

### Preview not working?
- Check for syntax errors
- Try: Editor → Canvas → Refresh Canvas
- Restart Xcode if needed

---

## 📚 Documentation

- **README.md** - Overview and installation
- **XCODE_GUIDE.md** - Detailed Xcode instructions  
- **API_INTEGRATION.md** - Backend integration details
- **CONTRIBUTING.md** - Development guidelines

---

## 🎨 Customization

### Change Colors:
Edit `Theme/ColorTheme.swift`:
```swift
static let flixiePrimary = Color(hex: "yourcolor")
```

### Modify Tab Bar:
Edit `ContentView.swift` TabView section

### Update App Name:
- Project settings → Display Name
- Or update in Info.plist

---

## 📱 Device Testing

### Simulator:
1. Select device (e.g., iPhone 15 Pro)
2. ⌘R to run

### Real Device:
1. Connect via USB
2. Select device
3. Trust computer on device
4. ⌘R to run

**Need to change backend URL for device:**
```
FLIXIE_API_URL = http://YOUR_COMPUTER_IP:3000/api
```

Find your IP:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

---

## 🚦 Next Steps

### Phase 1 (Current):
- ✅ Basic app structure
- ✅ All main views
- ✅ Color theme
- ✅ API service layer
- ✅ Models

### Phase 2 (Future):
- [ ] User authentication (JWT)
- [ ] Image loading/caching
- [ ] Video player
- [ ] Push notifications
- [ ] Offline support
- [ ] Share functionality
- [ ] Deep linking

### Phase 3 (Advanced):
- [ ] Real-time features (WebSocket)
- [ ] Watch together feature
- [ ] Comments/Reviews
- [ ] Favorites/Watchlist
- [ ] Recommendations

---

## 💡 Tips

1. **Use SwiftUI Previews** for fast iteration
2. **Test on multiple devices** (SE, Pro, iPad)
3. **Check both light and dark mode**
4. **Use Git branches** for features
5. **Comment complex logic**
6. **Keep functions small**
7. **Handle loading/error states**

---

## 🆘 Get Help

- **GitHub Issues** - Bug reports and features
- **Apple Developer Forums** - Swift/SwiftUI questions
- **Stack Overflow** - General programming help

---

**Happy Coding! 🎬**
