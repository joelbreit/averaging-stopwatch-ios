import SwiftUI

// MARK: - Design System Colors

enum Theme {
    // MARK: Accent Colors
    static let activeGreen = Color(hex: "34C759")
    static let stopRed = Color(hex: "FF3B30")
    static let actionBlue = Color(hex: "007AFF")
    static let neutralGray = Color(hex: "8E8E93")

    // MARK: Spacing (8pt grid)
    static let baseUnit: CGFloat = 8
    static let contentMargin: CGFloat = 16      // 2 units
    static let sectionSpacing: CGFloat = 24     // 3 units
    static let componentSpacing: CGFloat = 12   // 1.5 units

    // MARK: Button Sizes
    static let buttonSize: CGFloat = 80

    // MARK: Typography
    enum Typography {
        static let mainTimer = Font.system(size: 72, weight: .ultraLight, design: .monospaced)
        static let currentLapTimer = Font.system(size: 20, weight: .regular, design: .default)
        static let statistics = Font.system(size: 17, weight: .medium, design: .default)
        static let labels = Font.system(size: 15, weight: .regular, design: .default)
        static let lapNumber = Font.system(size: 17, weight: .medium, design: .default)
        static let lapTimes = Font.system(size: 17, weight: .regular, design: .default)
        static let buttonLabel = Font.system(size: 17, weight: .semibold, design: .default)
    }

    // MARK: Animation
    enum Animation {
        static let buttonPress = SwiftUI.Animation.easeOut(duration: 0.1)
        static let buttonRelease = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.6)
        static let lapRowInsert = SwiftUI.Animation.easeOut(duration: 0.25)
        static let timerGlow = SwiftUI.Animation.easeInOut(duration: 0.3)
    }
}

// MARK: - Color Extension for Hex Support

extension Color {
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

    // Adaptive colors for light/dark mode
    static let appBackground = Color(light: Color(hex: "FAFAFA"), dark: Color(hex: "0A0A0A"))
    static let appSurface = Color(light: Color(hex: "FFFFFF"), dark: Color(hex: "1C1C1E"))
    static let appPrimaryText = Color(light: Color(hex: "1A1A1A"), dark: Color(hex: "F5F5F5"))
    static let appSecondaryText = Color(light: Color(hex: "6B6B6B"), dark: Color(hex: "8E8E93"))

    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(dark)
            default:
                return UIColor(light)
            }
        })
    }
}
