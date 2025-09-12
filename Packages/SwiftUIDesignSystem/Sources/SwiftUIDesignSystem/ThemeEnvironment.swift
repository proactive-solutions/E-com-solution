import SwiftUI

// MARK: - Theme Environment
public struct ThemeEnvironment: ViewModifier {
    @StateObject private var themeManager = ThemeManager()
    @Environment(\.colorScheme) var systemColorScheme
    
    public func body(content: Content) -> some View {
        content
            .environmentObject(themeManager)
            .onChange(of: systemColorScheme) { newColorScheme in
                if themeManager.appearanceMode == .system {
                    themeManager.setTheme(for: newColorScheme)
                }
            }
            .onAppear {
                if themeManager.appearanceMode == .system {
                    themeManager.setTheme(for: systemColorScheme)
                }
            }
            .preferredColorScheme(themeManager.appearanceMode == .system ? nil : themeManager.colorScheme)
    }
}

public extension View {
    func withTheme() -> some View {
        modifier(ThemeEnvironment())
    }
}
