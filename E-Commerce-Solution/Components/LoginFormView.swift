//
//  LoginFormView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 17/06/2025.
//

import SwiftUI

// MARK: - Login Form Component
struct LoginFormView: View {
    @Binding var email: String
    @Binding var password: String
    @Binding var isPasswordVisible: Bool
    let validationError: String?
    let isLoading: Bool
    let onSignIn: () -> Void
    let onForgotPassword: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Email Field
            CustomTextField(
                title: "Email Address",
                text: $email,
                placeholder: "Enter your email",
                keyboardType: .emailAddress,
                hasError: hasEmailError
            ) {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
            }

            // Password Field
            CustomSecureField(
                title: "Password",
                text: $password,
                placeholder: "Enter your password",
                isVisible: $isPasswordVisible,
                hasError: hasPasswordError
            )

            // Error Message
            if let validationError = validationError {
                ErrorMessageView(message: validationError)
            }

            // Forgot Password Link
            HStack {
                Spacer()
                Button("Forgot Password?", action: onForgotPassword)
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
            }

            // Sign In Button
            PrimaryButton(
                title: "Sign In",
                isLoading: isLoading,
                action: onSignIn
            )
        }
    }

    private var hasEmailError: Bool {
        validationError?.contains("email") == true
    }

    private var hasPasswordError: Bool {
        validationError?.contains("password") == true
    }
}
