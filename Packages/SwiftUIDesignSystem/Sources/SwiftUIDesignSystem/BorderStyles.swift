import SwiftUI

public enum BorderRadius {
    public static let none: CGFloat = 0
    public static let small: CGFloat = 4
    public static let medium: CGFloat = 8
    public static let large: CGFloat = 12
    public static let extraLarge: CGFloat = 16
}

public enum BorderWidth {
    public static let none: CGFloat = 0
    public static let thin: CGFloat = 1
    public static let medium: CGFloat = 2
    public static let thick: CGFloat = 4
}

public extension Color {
    // Border Colors
    static let borderDefault = Color("BorderDefault")
    static let borderSubtle = Color("BorderSubtle")
    static let borderStrong = Color("BorderStrong")
    static let borderFocus = Color("BorderFocus")
    static let borderError = Color("BorderError")
    static let borderSuccess = Color("BorderSuccess")
    static let borderWarning = Color("BorderWarning")
}

public struct BorderStyle {
    public let width: CGFloat
    public let color: Color
    public let radius: CGFloat

    public static let none = BorderStyle(
        width: BorderWidth.none,
        color: .clear,
        radius: BorderRadius.none
    )

    public static let `default` = BorderStyle(
        width: BorderWidth.thin,
        color: .borderDefault,
        radius: BorderRadius.medium
    )

    public static let subtle = BorderStyle(
        width: BorderWidth.thin,
        color: .borderSubtle,
        radius: BorderRadius.medium
    )

    public static let strong = BorderStyle(
        width: BorderWidth.medium,
        color: .borderStrong,
        radius: BorderRadius.medium
    )

    public static let focus = BorderStyle(
        width: BorderWidth.medium,
        color: .borderFocus,
        radius: BorderRadius.medium
    )

    public static let error = BorderStyle(
        width: BorderWidth.medium,
        color: .borderError,
        radius: BorderRadius.medium
    )

    public static let success = BorderStyle(
        width: BorderWidth.medium,
        color: .borderSuccess,
        radius: BorderRadius.medium
    )

    public static let warning = BorderStyle(
        width: BorderWidth.medium,
        color: .borderWarning,
        radius: BorderRadius.medium
    )
}

public struct BorderModifier: ViewModifier {
    let style: BorderStyle

    public func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: style.radius)
                    .stroke(style.color, lineWidth: style.width)
            )
            .clipShape(RoundedRectangle(cornerRadius: style.radius))
    }
}

public extension View {
    func border(_ style: BorderStyle) -> some View {
        modifier(BorderModifier(style: style))
    }

    func cornerRadius(_ radius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
