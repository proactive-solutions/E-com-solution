//
//  LoginView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Models
import SwiftUI
import ValidationKit

// MARK: - Main Login View

struct LoginView: View {
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
                        title: NSLocalizedString("Email Address", comment: ""),
                        text: Binding(
                            get: {
                                guard let emailResult = viewModel.email else { return "" }
                                return switch emailResult {
                                case let .success(emailValue): emailValue.value
                                case .failure: ""
                                }
                            }, set: {
                                viewModel.set(email: $0)
                            }
                        ),
                        placeholder: NSLocalizedString("Enter your email", comment: ""),
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
                        title: NSLocalizedString("Password", comment: ""),
                        text: Binding(
                            get: {
                                guard let passwordResult = viewModel.password else { return "" }
                                return switch passwordResult {
                                case let .success(passwordValue): passwordValue.value
                                case .failure: ""
                                }
                            }, set: {
                                viewModel.set(password: $0)
                            }
                        ),
                        placeholder: NSLocalizedString("Enter your password", comment: ""),
                        isVisible: $viewModel.isPasswordVisible,
                        hasError: viewModel.passwordValidationError != nil
                    )

                    // Error Message
                    if let validationError = self.viewModel.passwordValidationError {
                        ErrorMessageView(message: validationError)
                    }

                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(
                            NSLocalizedString("Forgot Password?", comment: ""),
                            action: {}
                        )
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    }

                    // Sign In Button
                    PrimaryButton(
                        title: NSLocalizedString("Sign In", comment: ""),
                        isLoading: self.viewModel.isLoading,
                        action: {}
                    )
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
    LoginView()
}
