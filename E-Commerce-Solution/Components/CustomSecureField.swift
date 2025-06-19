//
//  CustomSecureField.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Custom Secure Field Component
struct CustomSecureField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    @Binding var isVisible: Bool
    let hasError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
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
