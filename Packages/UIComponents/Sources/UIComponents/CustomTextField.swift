//
//  CustomTextField.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Custom Text Field Component

public struct CustomTextField<TrailingContent: View>: View {
  let title: String
  @Binding private var text: String
    private let placeholder: String
    private let keyboardType: UIKeyboardType
    private let autoCorrection: Bool
    private let autoCapitalization: TextInputAutocapitalization?
    private let hasError: Bool
  @ViewBuilder private let trailingContent: () -> TrailingContent

    public init(
    title: String,
    text: Binding<String>,
    placeholder: String,
    keyboardType: UIKeyboardType = .default,
    autoCorrection: Bool = false,
    autoCapitalization: TextInputAutocapitalization? = nil,
    hasError: Bool = false,
    @ViewBuilder trailingContent: @escaping () -> TrailingContent = { EmptyView() }
  ) {
    self.title = title
    _text = text
    self.placeholder = placeholder
    self.keyboardType = keyboardType
    self.autoCorrection = autoCorrection
    self.autoCapitalization = autoCapitalization
    self.hasError = hasError
    self.trailingContent = trailingContent
  }

    public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(.primary)

      HStack {
        TextField(placeholder, text: $text)
          .keyboardType(keyboardType)
          .textFieldStyle(PlainTextFieldStyle())
          .autocorrectionDisabled(autoCorrection)
          .textInputAutocapitalization(autoCapitalization)

        trailingContent()
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 16)
      .background(Color(.systemBackground))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(hasError ? Color.red : Color(.systemGray4), lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 12))
    }
  }
}
