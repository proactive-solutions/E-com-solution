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
  let isEnabled: Bool
  let action: () -> Void

  init(title: String, isLoading: Bool = false, isEnabled: Bool = true, action: @escaping () -> Void) {
    self.title = title
    self.isLoading = isLoading
    self.isEnabled = isEnabled
    self.action = action
  }

  var body: some View {
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
      .background(isEnabled && !isLoading ? Color.blue : Color.blue.opacity(0.6))
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    .disabled(isLoading || !isEnabled)
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
      isEnabled: false,
      action: {}
    )
  }
  .padding()
}
