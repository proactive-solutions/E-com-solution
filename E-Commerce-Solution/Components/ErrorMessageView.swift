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
                .font(.system(size: 16))

            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.red)

            Spacer()
        }
    }
}
