# FlixieSwift

A modern iOS app for the Flixie streaming platform, built with SwiftUI and designed to work seamlessly with your Node.js/TypeScript/Prisma backend.

## Features

- 🏠 **Home Page** - Discover featured movies and shows
- 🎬 **Movies** - Browse and search through your movie collection
- 📺 **Shows** - Explore TV series and episodes
- 👥 **Groups** - Create and join watch groups with friends
- 👤 **Profile** - Manage your account and preferences
- 🎨 **Custom Theme** - Beautiful color scheme matching your Flixie brand

## Color Scheme

The app uses your Flixie brand colors:

- **Primary**: #947af1 (Purple)
- **Secondary**: #08a391 (Teal)
- **Tertiary**: #f1a77a (Peach)
- **Success**: #30c48d (Green)
- **Warning**: #ffd166 (Yellow)
- **Danger**: #e57373 (Red)
- **Light Text**: #c1ccdf
- **Medium Text**: #6c7a89
- **Dark Text**: #0f1c3391
- **Background**: #172b4d (Dark Blue)

## Getting Started with Xcode

### Prerequisites

- **macOS** 13.0 (Ventura) or later
- **Xcode** 15.0 or later
- **iOS** 15.0+ target device or simulator
- Your Flixie backend API running (Node.js/TypeScript/Prisma)

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/lauradouglas/FlixieSwift.git
   cd FlixieSwift
   ```

2. **Open in Xcode**
   ```bash
   open FlixieApp/FlixieApp.xcodeproj
   ```
   
   Alternatively, you can:
   - Launch Xcode
   - Select "Open a project or file"
   - Navigate to `FlixieApp/FlixieApp.xcodeproj`
   - Click "Open"

3. **Configure Your Backend URL**
   
   Before running the app, you need to configure your backend API URL:
   
   **Option 1: Environment Variable (Recommended)**
   - In Xcode, select the `FlixieApp` scheme at the top
   - Go to `Product` → `Scheme` → `Edit Scheme...`
   - Select `Run` in the left sidebar
   - Go to the `Arguments` tab
   - Under "Environment Variables", add:
     - Name: `FLIXIE_API_URL`
     - Value: `http://localhost:3000/api` (or your backend URL)
   
   **Option 2: Code Modification**
   - Open `FlixieApp/Services/APIService.swift`
   - Locate the `baseURL` initialization
   - Update the fallback URL to your backend address

4. **Select a Target Device**
   - In the Xcode toolbar, click the device selector next to the scheme selector
   - Choose either:
     - An iOS Simulator (e.g., "iPhone 15 Pro")
     - Your connected iOS device (requires Apple Developer account for device deployment)

5. **Build and Run**
   - Press `⌘R` (Command + R) or click the Play button (▶️) in the toolbar
   - Wait for the build to complete
   - The app will launch in the simulator or on your device

### Project Structure

```
FlixieApp/
├── FlixieApp.xcodeproj/      # Xcode project file
└── FlixieApp/                # Source code
    ├── FlixieAppApp.swift    # App entry point
    ├── ContentView.swift     # Main tab navigation
    ├── Views/                # UI screens
    │   ├── HomeView.swift
    │   ├── ProfileView.swift
    │   ├── MoviesView.swift
    │   ├── ShowsView.swift
    │   └── GroupView.swift
    ├── Services/             # API and networking
    │   ├── APIService.swift
    │   └── NetworkManager.swift
    ├── Models/               # Data models
    │   └── Models.swift
    ├── Theme/                # App styling
    │   └── ColorTheme.swift
    └── Assets.xcassets/      # Images and colors
```

## Backend Integration

### API Endpoints

The app expects your Node.js/TypeScript/Prisma backend to provide these endpoints:

#### Users
- `GET /api/users/:id` - Get user profile
- `PATCH /api/users/:id` - Update user profile

#### Movies
- `GET /api/movies` - List movies (paginated)
- `GET /api/movies/:id` - Get single movie
- `GET /api/movies/search?q=query` - Search movies

#### Shows
- `GET /api/shows` - List shows (paginated)
- `GET /api/shows/:id` - Get single show
- `GET /api/shows/search?q=query` - Search shows

#### Groups
- `GET /api/groups` - List groups (paginated)
- `GET /api/groups/:id` - Get single group
- `POST /api/groups` - Create new group
- `POST /api/groups/:id/join` - Join a group

### Expected Response Format

All API responses should follow this structure:

```json
{
  "success": true,
  "data": { /* your data here */ },
  "message": "Optional message"
}
```

For paginated endpoints:

```json
{
  "items": [ /* array of items */ ],
  "total": 100,
  "page": 1,
  "pageSize": 20,
  "hasMore": true
}
```

### CORS Configuration

Make sure your backend allows requests from the iOS app. For local development with the simulator, ensure your backend accepts requests from `localhost`.

## Development Tips

### Xcode Shortcuts
- `⌘R` - Build and run
- `⌘B` - Build only
- `⌘.` - Stop running app
- `⌘/` - Toggle comment
- `⌘⇧O` - Open quickly (search files)
- `⌘⇧K` - Clean build folder

### Using SwiftUI Previews
Most views include SwiftUI previews for rapid development:
1. Open any View file (e.g., `HomeView.swift`)
2. Click the "Resume" button in the preview canvas (right side of Xcode)
3. See live updates as you edit the code

### Debugging
- Set breakpoints by clicking the line numbers in the editor
- Use `print()` statements for console logging
- Check the Console pane (⌘⇧Y) for logs and errors

### Testing on Real Device
1. Connect your iPhone/iPad via USB
2. In Xcode, select your device from the device selector
3. You may need to:
   - Trust your Mac on the device
   - Enable Developer Mode in Settings → Privacy & Security
   - Sign the app with your Apple ID (Xcode → Preferences → Accounts)

## Customization

### Updating Colors
Edit `FlixieApp/Theme/ColorTheme.swift` to modify the color scheme.

### Adding Features
1. Create new view files in the `Views/` folder
2. Add new models in `Models/Models.swift`
3. Add API methods in `Services/APIService.swift`

### Modifying Navigation
Edit `ContentView.swift` to add/remove tabs or change navigation structure.

## Troubleshooting

### "Cannot connect to backend"
- Verify your backend is running
- Check the `FLIXIE_API_URL` environment variable
- For simulator: use `http://localhost:3000` instead of `http://127.0.0.1`
- For real device: use your computer's IP address (e.g., `http://192.168.1.100:3000`)

### Build Errors
- Clean build folder: `Product` → `Clean Build Folder` (⌘⇧K)
- Delete derived data: Xcode → Preferences → Locations → Derived Data (click arrow, delete folder)
- Restart Xcode

### Simulator Issues
- Reset simulator: `Device` → `Erase All Content and Settings`
- Try a different simulator device

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 5.0+

## License

This project is part of the Flixie platform.

## Support

For issues or questions about:
- The iOS app: Open an issue in this repository
- The backend API: Refer to your backend documentation