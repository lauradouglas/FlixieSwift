# Xcode Setup Guide

## Quick Start in Xcode

### 1. Opening the Project

**Double-click** `FlixieApp.xcodeproj` in Finder, or:

```bash
cd FlixieSwift
open FlixieApp/FlixieApp.xcodeproj
```

### 2. First Time Setup

When you first open the project in Xcode:

1. **Select a Development Team** (if you want to run on a real device)
   - Click on the project in the Project Navigator (left panel)
   - Select the "FlixieApp" target
   - Go to "Signing & Capabilities" tab
   - Choose your team from the dropdown

2. **Configure Environment Variables**
   - Click the scheme selector (next to the Run/Stop buttons)
   - Select "Edit Scheme..."
   - Go to Run → Arguments
   - Add Environment Variables:
     - `FLIXIE_API_URL` = `http://localhost:3000/api`

### 3. Xcode Interface Overview

```
┌─────────────────────────────────────────────────────────────┐
│  Toolbar: Scheme | Device | Run/Stop buttons                │
├──────────┬──────────────────────────────────┬───────────────┤
│          │                                  │               │
│ Project  │  Editor                          │   Inspector   │
│ Navigator│  (Code/Interface Builder)        │   (Settings)  │
│          │                                  │               │
│  Files   │  Your code appears here          │   File Info   │
│  here    │                                  │   & Settings  │
│          │                                  │               │
│          ├──────────────────────────────────┤               │
│          │  Debug Console                   │               │
│          │  (Logs and output)               │               │
└──────────┴──────────────────────────────────┴───────────────┘
```

### 4. Running the App

**Simulator:**
1. Click the device selector (next to scheme name)
2. Choose any iPhone simulator (e.g., "iPhone 15 Pro")
3. Press ⌘R or click the Play button (▶️)

**Real Device:**
1. Connect your iPhone/iPad via USB
2. Unlock the device and trust your Mac
3. Select your device from the device selector
4. Press ⌘R to build and run

### 5. Using SwiftUI Previews

For faster development without running the full app:

1. Open any View file (e.g., `HomeView.swift`)
2. Look for the canvas on the right side of Xcode
3. Click "Resume" button at the bottom of the canvas
4. The preview will show the view in real-time
5. Edit code and see changes immediately (Live Preview)

**Canvas not visible?**
- Press ⌘⌥↩ (Command + Option + Return) to toggle canvas
- Or: Editor → Canvas

### 6. Project Navigator Shortcuts

- ⌘1 - Project Navigator (files)
- ⌘2 - Source Control Navigator (git)
- ⌘3 - Bookmark Navigator
- ⌘4 - Find Navigator (search results)
- ⌘5 - Issue Navigator (errors/warnings)
- ⌘6 - Test Navigator
- ⌘7 - Debug Navigator
- ⌘8 - Breakpoint Navigator
- ⌘9 - Report Navigator (build logs)

### 7. Essential Xcode Shortcuts

**Building & Running:**
- ⌘R - Run app
- ⌘B - Build
- ⌘. - Stop
- ⌘⇧K - Clean build folder

**Editing:**
- ⌘/ - Comment/uncomment
- ⌘⇧O - Open quickly (file search)
- ⌘⇧J - Reveal in Project Navigator
- ⌘⌃E - Edit all in scope
- ⌃Space - Show completions

**Debugging:**
- ⌘\ - Toggle breakpoint
- ⌘Y - Toggle all breakpoints
- F6 - Step over
- F7 - Step into
- F8 - Continue

**Interface:**
- ⌘0 - Toggle Navigator
- ⌘⌥0 - Toggle Inspector
- ⌘⇧Y - Toggle Debug Area
- ⌘⌥↩ - Toggle Canvas

### 8. Connecting to Your Backend

**Local Development (Simulator):**

Your backend running on `localhost:3000` is accessible from the iOS Simulator.

Set environment variable:
```
FLIXIE_API_URL = http://localhost:3000/api
```

**Local Development (Real Device):**

Your device needs your computer's local IP address:

1. Find your Mac's IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
   Look for something like `192.168.1.100`

2. Set environment variable:
   ```
   FLIXIE_API_URL = http://192.168.1.100:3000/api
   ```

3. Make sure your device is on the same WiFi network

**Production:**
```
FLIXIE_API_URL = https://api.yourflixiesite.com/api
```

### 9. Building for Different Configurations

**Debug Build** (default):
- Includes debugging information
- Slower performance
- Easier to debug
- Use for development

**Release Build:**
- Optimized code
- Better performance
- Harder to debug
- Use for testing production-like behavior

To build Release:
1. Edit Scheme (⌘<)
2. Select "Run" on left
3. Change "Build Configuration" from Debug to Release

### 10. Viewing Console Logs

1. Run the app
2. Show Debug Area: ⌘⇧Y
3. Console output appears at the bottom
4. Use `print()` in Swift code to log messages

**Filter Console:**
- Type in the search box to filter logs
- Use the icons to filter by log level

### 11. Common Issues & Solutions

**"No such module" error:**
- Clean build folder: ⌘⇧K
- Close and reopen Xcode
- Delete `~/Library/Developer/Xcode/DerivedData/FlixieApp-*`

**Preview not working:**
- Make sure you're on a `.swift` file with `#Preview` macro
- Try: Editor → Canvas → Refresh Canvas
- Check for compilation errors in the file

**Simulator not showing:**
- Xcode → Preferences → Components
- Download the iOS simulator you want

**Cannot run on device - code signing:**
- Sign in with Apple ID: Xcode → Preferences → Accounts
- Select your team in Signing & Capabilities
- You may need Apple Developer Program for advanced features

### 12. File Organization Tips

Keep your code organized:

```
FlixieApp/
├── Models/           # Data structures
├── Views/            # UI screens
├── Services/         # API, networking, business logic
├── Theme/            # Colors, fonts, styling
├── Utilities/        # Helper functions
└── Resources/        # Images, data files
```

When adding new files:
1. File → New → File (⌘N)
2. Choose "Swift File" or "SwiftUI View"
3. Save in appropriate folder
4. Xcode automatically adds to project

### 13. Testing Your Views

**Quick Testing with Previews:**
```swift
#Preview {
    HomeView()
}
```

**Interactive Preview:**
```swift
#Preview {
    HomeView()
        .environment(\.colorScheme, .dark) // Test dark mode
}
```

### 14. Updating the UI Theme

All colors are defined in `Theme/ColorTheme.swift`:

```swift
static let flixiePrimary = Color(hex: "947af1")
```

Change the hex values to update the theme. Changes appear immediately in previews.

### 15. Adding Dependencies (if needed later)

**Swift Package Manager (recommended):**
1. File → Add Packages...
2. Enter package URL
3. Select version
4. Add to target

**Common packages:**
- Kingfisher (image loading)
- Alamofire (networking alternative)
- SwiftUIX (additional UI components)

### 16. Version Control (Git) in Xcode

- ⌘⌥C - Commit
- ⌘⌥X - Push  
- Source Control menu for all Git operations
- View → Navigators → Source Control Navigator (⌘2)

### 17. Debugging Network Requests

Add this to see all network requests:
```swift
// In NetworkManager.swift
print("📡 Request: \(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "")")
```

Use Charles Proxy or Proxyman to inspect traffic.

### 18. Performance Profiling

To check app performance:
1. Product → Profile (⌘I)
2. Choose "Time Profiler" or "Allocations"
3. Record and analyze

### 19. Screenshots

To take screenshots:
1. Run app in simulator
2. In simulator: File → Save Screen (⌘S)
3. Or use Xcode: Debug → View Debugging → Capture View Hierarchy

### 20. App Store Preparation (Future)

When ready to publish:
1. Create App Store Connect record
2. Archive: Product → Archive
3. Upload to App Store Connect
4. Submit for review

---

## Need Help?

- **Xcode Help**: Help → Xcode Help
- **Apple Developer Docs**: https://developer.apple.com/documentation/
- **SwiftUI Tutorials**: https://developer.apple.com/tutorials/swiftui

Happy coding! 🚀
