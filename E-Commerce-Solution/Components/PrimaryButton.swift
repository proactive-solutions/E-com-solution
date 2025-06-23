//
//  PrimaryButton.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Primary Button Component

struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isLoading)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        PrimaryButton(
            title: "Button",
            isLoading: false,
            action: {}
        )
        PrimaryButton(
            title: "Button",
            isLoading: true,
            action: {}
        )
    }
    .padding()
}
