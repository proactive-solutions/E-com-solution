//
//  SocialLoginButton.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Social Login Button Component

struct SocialLoginButton<IconContent: View>: View {
  let title: String
  let icon: String
  let backgroundColor: Color
  let foregroundColor: Color
  let action: () -> Void
  @ViewBuilder let iconContent: () -> IconContent

  init(
    title: String,
    icon: String,
    backgroundColor: Color,
    foregroundColor: Color,
    action: @escaping () -> Void,
    @ViewBuilder iconContent: @escaping () -> IconContent = { EmptyView() }
  ) {
    self.title = title
    self.icon = icon
    self.backgroundColor = backgroundColor
    self.foregroundColor = foregroundColor
    self.action = action
    self.iconContent = iconContent
  }

  var body: some View {
    Button(action: action) {
      HStack(spacing: 12) {
        if IconContent.self == EmptyView.self {
          Text(icon)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(foregroundColor)
        } else {
          iconContent()
        }

        Text(title)
          .font(.headline)
          .fontWeight(.medium)
          .foregroundColor(foregroundColor)

        Spacer()
      }
      .padding(.horizontal, 20)
      .frame(height: 56)
      .background(backgroundColor)
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(.systemGray4), lineWidth: 1)
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  SocialLoginButton(
    title: "Google",
    icon: "",
    backgroundColor: Color.red,
    foregroundColor: Color.white,
    action: {}) {
      EmptyView()
    }
}
