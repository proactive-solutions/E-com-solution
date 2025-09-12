import SwiftUI

//public extension Font {
//    static func custom(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
//        switch style {
//        case .largeTitle : .system(size: 48, weight: weight)
//        case .title      : .system(size: 36, weight: weight)
//        case .headline   : .system(size: 24, weight: weight)
//        case .title2     : .system(size: 20, weight: weight)
//        case .title3     : .system(size: 20, weight: weight)
//        case .body       : .system(size: 17, weight: weight)
//        case .callout    : .system(size: 16, weight: weight)
//        case .subheadline: .system(size: 15, weight: weight)
//        case .footnote   : .system(size: 13, weight: weight)
//        case .caption    : .system(size: 12, weight: weight)
//        case .caption2   : .system(size: 10, weight: weight)
//        @unknown default : .system(size: 10, weight: weight)
//        }
//    }
//}

// MARK: - Simple Font Scale
public enum FontScale: CaseIterable {
    case xs, sm, base, lg, xl, xl2, xl3, xl4, xl5

    public var size: CGFloat {
        switch self {
        case .xs:   return 10
        case .sm:   return 12
        case .base: return 14
        case .lg:   return 16
        case .xl:   return 18
        case .xl2:  return 20
        case .xl3:  return 24
        case .xl4:  return 30
        case .xl5:  return 36
        }
    }
}

// MARK: - Font Extension
public extension Font {
    // Simple scale-based fonts
    static func app(_ scale: FontScale, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        Font.system(size: scale.size, weight: weight, design: design)
    }

    // Semantic shortcuts (optional - use what makes sense for your app)
    static let heading1 = Font.app(.xl5, weight: .bold)
    static let heading2 = Font.app(.xl4, weight: .semibold)
    static let heading3 = Font.app(.xl3, weight: .medium)
    static let bodyText = Font.app(.base)
    static let caption = Font.app(.sm)
}
