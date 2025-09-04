import SwiftUI

public struct ShadowStyle {
    public let radius: CGFloat
    public let offset: CGSize
    public let opacity: Double
}

public enum Elevation {
    public static let none = ShadowStyle(radius: 0, offset: .zero, opacity: 0)
    public static let level1 = ShadowStyle(radius: 2, offset: CGSize(width: 0, height: 1), opacity: 0.1)
    public static let level2 = ShadowStyle(radius: 4, offset: CGSize(width: 0, height: 2), opacity: 0.15)
    public static let level3 = ShadowStyle(radius: 8, offset: CGSize(width: 0, height: 4), opacity: 0.2)
    public static let level4 = ShadowStyle(radius: 16, offset: CGSize(width: 0, height: 8), opacity: 0.25)
    public static let level5 = ShadowStyle(radius: 24, offset: CGSize(width: 0, height: 12), opacity: 0.3)
}

fileprivate struct ElevationModifier: ViewModifier {
    let shadowStyle: ShadowStyle
    
    fileprivate func body(content: Content) -> some View {
        content.shadow(
            color: Color.black.opacity(shadowStyle.opacity),
            radius: shadowStyle.radius,
            x: shadowStyle.offset.width,
            y: shadowStyle.offset.height
        )
    }
}

public extension View {
    func elevation(_ style: ShadowStyle) -> some View {
        modifier(ElevationModifier(shadowStyle: style))
    }
}
