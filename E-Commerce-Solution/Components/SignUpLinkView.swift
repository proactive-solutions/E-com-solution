//
//  SignUpLinkView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Sign Up Link Component
struct SignUpLinkView: View {
    var body: some View {
        HStack {
            Text("Don't have an account?")
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            Button("Sign Up") {
                // Handle sign up navigation
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.blue)
        }
    }
}
