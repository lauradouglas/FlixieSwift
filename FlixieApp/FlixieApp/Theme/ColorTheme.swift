import SwiftUI

extension Color {
    // Flixie Color Theme
    static let flixiePrimary = Color(hex: "947af1")
    static let flixieSecondary = Color(hex: "08a391")
    static let flixieTertiary = Color(hex: "f1a77a")
    static let flixieSuccess = Color(hex: "30c48d")
    static let flixieWarning = Color(hex: "ffd166")
    static let flixieDanger = Color(hex: "e57373")
    static let flixieLightText = Color(hex: "c1ccdf")
    static let flixieMediumText = Color(hex: "6c7a89")
    static let flixieDarkText = Color(hex: "0f1c3391")
    static let flixieBackground = Color(hex: "172b4d")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
