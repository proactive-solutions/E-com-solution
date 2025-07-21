//
//  PasswordView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//
import SwiftUI

struct PasswordView: View {
    @ObservedObject var viewModel: PasswordViewModel

    var body: some View {
        VStack {
            // Password Field
            CustomSecureField(
                title: "Password",
                text: $viewModel.userPassword,
                placeholder: "Enter your password",
                isVisible: $viewModel.isPasswordVisible,
                hasError: viewModel.passwordValidationError != nil
            )
            .rainbowDebug()

            // Error Message
            if let validationError = self.viewModel.passwordValidationError {
                ErrorMessageView(message: validationError)
                    .rainbowDebug()
            }
        }
    }
}
