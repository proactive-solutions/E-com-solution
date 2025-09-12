import SwiftUI

public enum ButtonStyleType {
    case primary
    case secondary
    case outline
    case ghost
    case destructive
}

public enum ButtonSizeType {
    case small
    case medium
    case large
}

public struct AppButton: View {
    let title: String
    let style: ButtonStyleType
    let size: ButtonSizeType
    let action: () -> Void
    let isLoading: Bool
    let isDisabled: Bool
    
    init(
        _ title: String,
        style: ButtonStyleType = .primary,
        size: ButtonSizeType = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    @EnvironmentObject var themeManager: ThemeManager
    
    public var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                }
                Text(title)
            }
            .font(.app(.lg, weight: .medium))
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .frame(height: buttonHeight)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .cornerRadius(BorderRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: BorderRadius.medium)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .opacity(isDisabled ? 0.5 : 1.0)
        }
        .disabled(isDisabled || isLoading)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: themeManager.currentTheme.primary
        case .secondary: themeManager.currentTheme.secondary
        case .outline, .ghost: .clear
        case .destructive: themeManager.currentTheme.error
        }
    }
    
    private var textColor: Color {
        switch style {
        case .primary, .destructive: themeManager.currentTheme.textInverse
        case .secondary: themeManager.currentTheme.textPrimary
        case .outline: themeManager.currentTheme.primary
        case .ghost: themeManager.currentTheme.textPrimary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline: themeManager.currentTheme.primary
        default: .clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outline: BorderWidth.thin
        default: BorderWidth.none
        }
    }
    
    private var buttonHeight: CGFloat {
        switch size {
        case .small: 32
        case .medium: 44
        case .large: 56
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch size {
        case .small: Spacing.small
        case .medium: Spacing.medium
        case .large: Spacing.large
        }
    }
    
    private var verticalPadding: CGFloat {
        switch size {
        case .small: Spacing.xSmall
        case .medium: Spacing.small
        case .large: Spacing.medium
        }
    }
}

#Preview {
    AppButton(
        "Button",
        style: .primary,
        size: .medium,
        isLoading: false,
        isDisabled: false
    ) { }
}
