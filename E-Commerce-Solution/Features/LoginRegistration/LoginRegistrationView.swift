//
//  LoginRegistrationView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import DataModels
import SwiftUI
import ValidationKit

// MARK: - Main Login View

struct LoginRegistrationView: View {
    @StateObject private var viewModel = LoginRegistrationViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                LoginHeaderView()

                // Toggle Section
                LoginToggleView(selectedMode: $viewModel.selectedMode)

                VStack(spacing: 20) {
                    // Email Field
                    CustomTextField(
                        title: "Email Address",
                        text: $viewModel.userEmail,
                        placeholder: "Enter your email",
                        keyboardType: .emailAddress,
                        autoCorrection: false,
                        autoCapitalization: .never,
                        hasError: viewModel.emailValidationError != nil
                    ) {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                    }

                    if let validationError = self.viewModel.emailValidationError {
                        ErrorMessageView(message: validationError)
                    }

                    // Password Field
                    CustomSecureField(
                        title: "Password",
                        text: $viewModel.userPassword,
                        placeholder: "Enter your password",
                        isVisible: $viewModel.isPasswordVisible,
                        hasError: viewModel.passwordValidationError != nil
                    )

                    // Error Message
                    if let validationError = self.viewModel.passwordValidationError {
                        ErrorMessageView(message: validationError)
                    }

                    if self.viewModel.selectedMode == .signUp {
                        // Name field
                        CustomTextField(
                            title: "Name",
                            text: $viewModel.userName,
                            placeholder: "Enter your full name",
                            keyboardType: .emailAddress,
                            autoCorrection: false,
                            autoCapitalization: .never,
                            hasError: viewModel.emailValidationError != nil
                        ) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.gray)
                        }

                        if let validationError = self.viewModel.nameValidationError {
                            ErrorMessageView(message: validationError)
                        }
                    }

                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(
                            "Forgot Password?",
                            action: {}
                        )
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    }

                    if self.viewModel.selectedMode == .signUp {
                        PrimaryButton(
                            title: "Sign Up",
                            isLoading: viewModel.isLoading,
                            action: viewModel.signup
                        )
                    }

                    if self.viewModel.selectedMode == .login {
                        // Sign In Button
                        PrimaryButton(
                            title: "Sign In",
                            isLoading: viewModel.isLoading,
                            action: viewModel.signIn
                        )
                    }
                }

                // Social Login Section
                SocialLoginView(
                    onGoogleLogin: viewModel.signInWithGoogle,
                    onAppleLogin: viewModel.signInWithApple
                )

                // Sign Up Link
                SignUpLinkView()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - Preview

#Preview {
    LoginRegistrationView()
}
