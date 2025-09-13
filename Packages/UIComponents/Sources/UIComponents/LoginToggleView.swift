//
//  LoginToggleView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI
import DataModels

// MARK: - Login Toggle Component

public struct LoginToggleView: View {
    public init(selectedMode: Binding<UserAuthMode>) {
        _selectedMode = selectedMode
    }
    
    @Binding private var selectedMode: DataModels.UserAuthMode

    public var body: some View {
    HStack(spacing: 0) {
      // Login Button
      createToggleButton(
        title: "Login",
        isSelected: selectedMode == .existing,
        action: {
          if selectedMode == .existing { return }
          selectedMode = .existing
        }
      )

      // Sign Up Button
      createToggleButton(
        title: "Sign Up",
        isSelected: selectedMode == .new,
        action: {
          if selectedMode == .new { return }
          selectedMode = .new
        }
      )
    }
    .background(Color(.systemGray6))
    .clipShape(Capsule())
  }

  private func createToggleButton(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Text(title)
        .font(.body)
        .fontWeight(.medium)
        .foregroundColor(isSelected ? .white : .secondary)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(isSelected ? Color.blue : Color.clear)
        .clipShape(Capsule())
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  VStack {
    LoginToggleView(selectedMode: .constant(.existing))
    LoginToggleView(selectedMode: .constant(.new))
  }
  .padding()
}
