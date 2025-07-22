//
//  LoginRegistrationView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import DataModels
import SwiftUI
import ValidationKit
import ComposableArchitecture

// MARK: - Main Login View

struct LoginRegistrationView: View {
    @StateObject private var viewModel = LoginRegistrationViewModel()
    let emailStore = Store(initialState: EmailValidationFeature.State()) {
        EmailValidationFeature()
    }
    private let passwordViewModel = PasswordViewModel()
    private let nameViewModel = NameViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header Section
                LoginHeaderView()
                    .rainbowDebug()

                // Toggle Section
                LoginToggleView(selectedMode: $viewModel.selectedMode)
                    .rainbowDebug()

                VStack(spacing: 20) {
                    // Email Field
                    EmailValidationView(store: emailStore)
                    PasswordView(viewModel: passwordViewModel)

                    if self.viewModel.selectedMode == .new {
                        NameView(viewModel: nameViewModel)
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
                    .rainbowDebug()

                    if self.viewModel.selectedMode == .new {
                        PrimaryButton(
                            title: "Sign Up",
                            isLoading: viewModel.isLoading,
                            action: {
                                guard
                                    let email = emailStore.validatedEmail,
                                    let password = try? passwordViewModel.passwordResult?.get(),
                                    let name = try? nameViewModel.nameResult?.get()
                                else { return }
                                viewModel.signup(email: email, password: password, name: name)
                            }
                        )
                        .alert(isPresented: Binding(
                            get: {
                                guard let _ = viewModel.authenticationService.errorMessage else { return false }
                                return true
                            },
                            set: { value in
                                viewModel.authenticationService.errorMessage = value
                                    ? viewModel.authenticationService.errorMessage
                                    : nil
                            }
                        )) {
                            Alert(
                                title: Text("Attention"),
                                message: Text(viewModel.authenticationService.errorMessage ?? "Unknown error!"),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }

                    if self.viewModel.selectedMode == .existing {
                        // Sign In Button
                        PrimaryButton(
                            title: "Sign In",
                            isLoading: viewModel.isLoading,
                            action: {
                                guard
                                    let email = emailStore.validatedEmail,
                                    let password = try? passwordViewModel.passwordResult?.get()
                                else { return }
                                viewModel.signIn(email: email, password: password)
                            }
                        )
                        .alert(isPresented: Binding(
                            get: {
                                guard let _ = viewModel.authenticationService.errorMessage else { return false }
                                return true
                            },
                            set: { value in
                                viewModel.authenticationService.errorMessage = value
                                    ? viewModel.authenticationService.errorMessage
                                    : nil
                            }
                        )) {
                            Alert(
                                title: Text("Attention"),
                                message: Text(viewModel.authenticationService.errorMessage ?? "Unknown error!"),
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                    }
                }

                // Social Login Section
                SocialLoginView(
                    onGoogleLogin: viewModel.signInWithGoogle,
                    onAppleLogin: viewModel.signInWithApple
                )
                .rainbowDebug()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .rainbowDebug()
        }
        .background(Color(.systemBackground))
        .rainbowDebug()
    }
}

// MARK: - Preview

#Preview {
    LoginRegistrationView()
}

#if DEBUG
    fileprivate let rainbowDebugColors: [Color] = [
        .purple, .blue, .green,
        .yellow, .orange, .red,
        .mint, .cyan, .pink, .teal,
    ]

    extension View {
        func rainbowDebug() -> some View {
            background(rainbowDebugColors.randomElement()!)
        }
    }
#else
    extension View {
        func rainbowDebug() -> some View {
            self
        }
    }
#endif
