import SwiftUI


struct Theme {
    static let orange      = Color(hex: "#F5A623")
    static let background  = Color(hex: "#0A0A0A")
    static let surface     = Color(hex: "#141414")
    static let surface2    = Color(hex: "#1C1C1C")
    static let border      = Color(hex: "#2A2A2A")
    static let textPrimary = Color(hex: "#F0EDE6")
    static let textMuted   = Color(hex: "#555555")
    static let blue        = Color(hex: "#3A5FF5")
    static let pink        = Color(hex: "#E03E5C")
    static let green       = Color(hex: "#22C47A")
    static let amber       = Color(hex: "#F5A623")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:   Double(r) / 255,
                  green: Double(g) / 255,
                  blue:  Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}


extension Font {
    static func bebasNeue(size: CGFloat) -> Font {
        .custom("BebasNeue-Regular", size: size)
    }
}

