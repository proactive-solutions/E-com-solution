//
//  EmailView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//
import SwiftUI

struct EmailView: View {
    @ObservedObject var viewModel: EmailViewModel

    var body: some View {
        VStack {
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
            .rainbowDebug()

            if let validationError = viewModel.emailValidationError {
                ErrorMessageView(message: validationError)
                    .rainbowDebug()
            }
        }
    }
}
