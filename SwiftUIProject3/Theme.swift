import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case light, dark, highContrast

    var id: String { self.rawValue }

    var backgroundColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color.black
        case .highContrast: return Color.yellow
        }
    }

    var textColor: Color {
        switch self {
        case .light: return Color.black
        case .dark: return Color.white
        case .highContrast: return Color.red
        }
    }

    var cellColor: Color {
        switch self {
        case .light: return Color.gray.opacity(0.1)
        case .dark: return Color.gray.opacity(0.3)
        case .highContrast: return Color.orange
        }
    }
}
