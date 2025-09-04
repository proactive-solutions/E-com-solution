import SwiftUI

// MARK: - Theme Protocol
public protocol Theme {
    // Colors
    var background: Color { get }
    var surface: Color { get }
    var primary: Color { get }
    var secondary: Color { get }
    var accent: Color { get }

    // Text Colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textTertiary: Color { get }
    var textInverse: Color { get }
    
    // Border Colors
    var borderPrimary: Color { get }
    var borderSecondary: Color { get }
    var borderFocus: Color { get }
    
    // Status Colors
    var success: Color { get }
    var warning: Color { get }
    var error: Color { get }
    var info: Color { get }
    
    // Shadow Colors
    var shadowColor: Color { get }
}

// MARK: - Light Theme
public struct LightTheme: Theme {
    public let background = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    public let surface = Color(red: 0.98, green: 0.98, blue: 0.98) // #FAFAFA
    public let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF
    public let secondary = Color(red: 0.35, green: 0.34, blue: 0.84) // #5856D6
    public let accent = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500

    public let textPrimary = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    public let textSecondary = Color(red: 0.24, green: 0.24, blue: 0.26) // #3C3C43
    public let textTertiary = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    public let textInverse = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF

    public let borderPrimary = Color(red: 0.78, green: 0.78, blue: 0.80) // #C7C7CC
    public let borderSecondary = Color(red: 0.90, green: 0.90, blue: 0.92) // #E5E5EA
    public let borderFocus = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF

    public let success = Color(red: 0.20, green: 0.78, blue: 0.35) // #34C759
    public let warning = Color(red: 1.0, green: 0.58, blue: 0.0) // #FF9500
    public let error = Color(red: 1.0, green: 0.23, blue: 0.19) // #FF3B30
    public let info = Color(red: 0.0, green: 0.48, blue: 1.0) // #007AFF

    public let shadowColor = Color.black.opacity(0.1)
}

// MARK: - Dark Theme
public struct DarkTheme: Theme {
    public let background = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000
    public let surface = Color(red: 0.11, green: 0.11, blue: 0.12) // #1C1C1E
    public let primary = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF
    public let secondary = Color(red: 0.64, green: 0.63, blue: 0.87) // #A29BDF
    public let accent = Color(red: 1.0, green: 0.62, blue: 0.04) // #FF9F0A

    public let textPrimary = Color(red: 1.0, green: 1.0, blue: 1.0) // #FFFFFF
    public let textSecondary = Color(red: 0.92, green: 0.92, blue: 0.96) // #EBEBF5
    public let textTertiary = Color(red: 0.56, green: 0.56, blue: 0.58) // #8E8E93
    public let textInverse = Color(red: 0.0, green: 0.0, blue: 0.0) // #000000

    public let borderPrimary = Color(red: 0.23, green: 0.23, blue: 0.26) // #3A3A3C
    public let borderSecondary = Color(red: 0.17, green: 0.17, blue: 0.18) // #2C2C2E
    public let borderFocus = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF

    public let success = Color(red: 0.19, green: 0.82, blue: 0.35) // #30D158
    public let warning = Color(red: 1.0, green: 0.62, blue: 0.04) // #FF9F0A
    public let error = Color(red: 1.0, green: 0.27, blue: 0.23) // #FF453A
    public let info = Color(red: 0.04, green: 0.52, blue: 1.0) // #0A84FF

    public let shadowColor = Color.black.opacity(0.3)
}

// MARK: - Theme Manager
public enum AppearanceMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
}

public final class ThemeManager: ObservableObject {
    @Published public var currentTheme: Theme
    @Published public var appearanceMode = AppearanceMode.system {
        didSet {
            updateTheme()
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: "AppearanceMode")
        }
    }
    
    @Published var colorScheme = ColorScheme.light

    init() {
        // Load saved preference
        if let savedMode = UserDefaults.standard.string(forKey: "AppearanceMode"),
           let mode = AppearanceMode(rawValue: savedMode) {
            self.appearanceMode = mode
        }
        
        // Set initial theme
        self.currentTheme = LightTheme()
        updateTheme()
    }
    
    private func updateTheme() {
        switch appearanceMode {
        case .light:
            currentTheme = LightTheme()
            colorScheme = .light
        case .dark:
            currentTheme = DarkTheme()
            colorScheme = .dark
        case .system:
            // This will be handled by the environment
            currentTheme = LightTheme() // Default, will be overridden by environment
        }
    }
    
    func setTheme(for colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            currentTheme = LightTheme()
        case .dark:
            currentTheme = DarkTheme()
        @unknown default:
            currentTheme = LightTheme()
        }
        self.colorScheme = colorScheme
    }
}
