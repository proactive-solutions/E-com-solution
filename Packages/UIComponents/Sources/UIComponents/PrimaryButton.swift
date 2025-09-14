//
//  PrimaryButton.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Primary Button Component

public struct PrimaryButton: View {
  private let title: String
  private let isLoading: Bool
  private let action: () -> Void

    public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
    self.title = title
    self.isLoading = isLoading
    self.action = action
  }

    public var body: some View {
    Button(action: action) {
      HStack {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
        } else {
          Text(title)
            .font(.body)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        }
      }
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      .background(!isLoading ? Color.blue : Color.blue.opacity(0.6))
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
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
    PrimaryButton(
      title: "Disabled Button",
      action: {}
    )
  }
  .padding()
}
