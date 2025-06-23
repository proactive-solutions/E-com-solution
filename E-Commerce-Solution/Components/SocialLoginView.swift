//
//  SocialLoginView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Social Login Component

struct SocialLoginView: View {
    let onGoogleLogin: () -> Void
    let onAppleLogin: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("or")
                .font(.system(size: 16))
                .foregroundColor(.secondary)

            VStack(spacing: 12) {
                SocialLoginButton(
                    title: "Continue with Google",
                    icon: "G",
                    backgroundColor: .white,
                    foregroundColor: .black,
                    action: onGoogleLogin
                )

                SocialLoginButton(
                    title: "Continue with Apple",
                    icon: "",
                    backgroundColor: .white,
                    foregroundColor: .black,
                    action: onAppleLogin
                ) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    SocialLoginView {

    } onAppleLogin: {

    }
    .padding()
}
