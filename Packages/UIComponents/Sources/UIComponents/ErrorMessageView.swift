//
//  ErrorMessageView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Error Message Component

public struct ErrorMessageView: View {
    public  init(message: String) {
        self.message = message
    }
    
    private let message: String

    public var body: some View {
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
