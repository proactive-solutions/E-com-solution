//
//  CustomSecureField.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Custom Secure Field Component

public struct CustomSecureField: View {
    public init(title: String, text: Binding<String>, placeholder: String, isVisible: Binding<Bool>, hasError: Bool) {
        self.title = title
        _text = text
        self.placeholder = placeholder
        _isVisible = isVisible
        self.hasError = hasError
    }

    private let title: String
    @Binding private var text: String
    private let placeholder: String
    @Binding private var isVisible: Bool
    private let hasError: Bool

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            HStack {
                if isVisible {
                    TextField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                } else {
                    SecureField(placeholder, text: $text)
                        .textFieldStyle(PlainTextFieldStyle())
                }

                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
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
