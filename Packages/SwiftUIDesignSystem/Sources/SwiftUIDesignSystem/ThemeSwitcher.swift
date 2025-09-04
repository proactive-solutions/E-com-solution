import SwiftUI

// MARK: - Theme Switcher Component
public struct ThemeSwitcher: View {
    @EnvironmentObject var themeManager: ThemeManager

    public var body: some View {
        Picker("Appearance", selection: $themeManager.appearanceMode) {
            ForEach(AppearanceMode.allCases, id: \.self) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}
