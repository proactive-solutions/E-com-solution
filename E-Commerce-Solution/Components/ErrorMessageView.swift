//
//  ErrorMessageView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Error Message Component

struct ErrorMessageView: View {
  let message: String

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: "exclamationmark.circle.fill")
        .foregroundColor(.red)
        .font(.caption)

      Text(message)
        .font(.caption)
        .foregroundColor(.red)

      Spacer()
    }
  }
}

#Preview {
  VStack {
    ErrorMessageView(message: "Email is empty")
    ErrorMessageView(message: "Invalid mobile number")
    ErrorMessageView(message: "Password is too short")
  }
  .padding()
}
