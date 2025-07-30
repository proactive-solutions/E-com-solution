//
//  CustomTextField.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Custom Text Field Component

struct CustomTextField<TrailingContent: View>: View {
  let title: String
  @Binding var text: String
  let placeholder: String
  let keyboardType: UIKeyboardType
  let autoCorrection: Bool
  let autoCapitalization: TextInputAutocapitalization?
  let hasError: Bool
  @ViewBuilder let trailingContent: () -> TrailingContent

  init(
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

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 16, weight: .medium))
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
