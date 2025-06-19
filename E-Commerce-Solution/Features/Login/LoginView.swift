//
//  LoginView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import SwiftUI

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

                // Form Section
                LoginFormView(
                    email: $viewModel.email,
                    password: $viewModel.password,
                    isPasswordVisible: $viewModel.isPasswordVisible,
                    validationError: viewModel.validationError,
                    isLoading: viewModel.isLoading,
                    onSignIn: viewModel.signIn,
                    onForgotPassword: viewModel.forgotPassword
                )

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

// MARK: - View Model
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var selectedMode: LoginMode = .login
    @Published var validationError: String?
    @Published var isLoading = false

    // MARK: - Pure Functions for Validation
    private func validateEmail(_ email: String) -> ValidationResult {
        func isValidEmailFormat(_ email: String) -> Bool {
            let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }

        if email.isEmpty {
            return .failure("Email is required")
        } else if !isValidEmailFormat(email) {
            return .failure("Invalid email format")
        }
        return .success
    }

    private func validatePassword(_ password: String) -> ValidationResult {
        if password.isEmpty {
            return .failure("Password is required")
        } else if password.count < 6 {
            return .failure("Password must be at least 6 characters")
        }
        return .success
    }

    private func validateLoginForm(email: String, password: String) -> ValidationResult {
        let emailValidation = validateEmail(email)
        let passwordValidation = validatePassword(password)

        if case .failure(let emailError) = emailValidation {
            return .failure("Invalid email or password")
        }

        if case .failure(let passwordError) = passwordValidation {
            return .failure("Invalid email or password")
        }

        return .success
    }

    // MARK: - Actions
    func signIn() {
        let validation = validateLoginForm(email: email, password: password)

        switch validation {
        case .failure(let error):
            validationError = error
        case .success:
            performSignIn()
        }
    }

    private func performSignIn() {
        isLoading = true
        validationError = nil

        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            // Handle sign in result
        }
    }

    func forgotPassword() {
        // Handle forgot password
    }

    func signInWithGoogle() {
        // Handle Google sign in
    }

    func signInWithApple() {
        // Handle Apple sign in
    }
}

enum ValidationResult {
    case success
    case failure(String)
}

// MARK: - Preview
#Preview {
    LoginView()
}

