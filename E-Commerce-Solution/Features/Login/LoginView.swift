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
    @StateObject private var viewModel = LoginViewModel()

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
                        text: Binding(
                            get: {
                                guard let emailResult = viewModel.email else {
                                    return ""
                                }
                                switch emailResult {
                                case .success(let emailValue):
                                    return emailValue.value
                                case .failure:
                                    return ""
                                }
                            }, set: { newTextInput in
                                do {
                                    let email = try Models.EmailAddress(newTextInput)
                                    self.viewModel.email = .success(email)
                                } catch let error as Validator.EmailValidationError {
                                    self.viewModel.email = .failure(error)
                                } catch { }
                        }),
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
                        text: Binding(
                            get: {
                                guard let passwordResult = viewModel.password else {
                                    return ""
                                }
                                switch passwordResult {
                                case .success(let passwordValue):
                                    return passwordValue.value
                                case .failure:
                                    return ""
                                }
                            }, set: { newTextInput in
                                do {
                                    let password = try Models.Password(newTextInput)
                                    self.viewModel.password = .success(password)
                                } catch let error as Validator.PasswordValidationError {
                                    self.viewModel.password = .failure(error)
                                } catch { }
                        }),
                        placeholder: "Enter your password",
                        isVisible: self.$viewModel.isPasswordVisible,
                        hasError: hasPasswordError
                    )

                    // Error Message
                    if let validationError = self.viewModel.validationError {
                        ErrorMessageView(message: validationError)
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

                    // Sign In Button
                    PrimaryButton(
                        title: "Sign In",
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

    private var hasEmailError: Bool {
        viewModel.validationError?.contains("email") == true
    }

    private var hasPasswordError: Bool {
        viewModel.validationError?.contains("password") == true
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
