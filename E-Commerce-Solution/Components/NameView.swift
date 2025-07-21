//
//  NameView.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//

import SwiftUI

struct NameView: View {
    @ObservedObject var viewModel: NameViewModel

    var body: some View {
        VStack {
            // Name field
            CustomTextField(
                title: "Name",
                text: $viewModel.userName,
                placeholder: "Enter your full name",
                keyboardType: .emailAddress,
                autoCorrection: false,
                autoCapitalization: .never,
                hasError: viewModel.nameValidationError != nil
            ) {
                Image(systemName: "pencil.circle")
                    .foregroundColor(.gray)
            }
            .rainbowDebug()

            if let validationError = self.viewModel.nameValidationError {
                ErrorMessageView(message: validationError)
                    .rainbowDebug()
            }
        }
    }
}
