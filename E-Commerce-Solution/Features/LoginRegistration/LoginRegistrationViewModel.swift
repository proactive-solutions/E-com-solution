//
//  LoginRegistrationViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Combine
import DataModels
import Foundation
import ValidationKit

@MainActor
final class LoginRegistrationViewModel: ObservableObject {
    // MARK: Published properties

    @Published var isLoading = false
    @Published var selectedMode = UserAuthMode.existing

    // MARK: Private properties

    lazy var authenticationService = AuthenticationService()

    // MARK: - Actions

    func signIn() {
//        Task { [weak self] in
//            guard let self else { return }
//            self.isLoading = true
//            defer { self.isLoading = false }
//            guard let email = self.email, let password = self.password else { return }
//            // Need to proceed in case of valid email, and password only.
//            // For any other case authentication cannot be done.
//            switch (email, password) {
//            case let (.success(email), .success(pass)):
//                await self.authenticationService.signIn(
//                    email: email,
//                    password: pass
//                )
//            default:
//                return
//            }
//        }
    }

    func signup() {
//        Task { [weak self] in
//            guard
//                let self,
//                let email = self.email,
//                let password = self.password,
//                let name = self.name
//            else { return }
//            self.isLoading = true
//            defer { self.isLoading = false }
//            // Need to proceed in case of valid email, and password only.
//            // For any other case authentication cannot be done.
//            switch (email, password, name) {
//            case let (.success(email), .success(pass), .success(name)):
//                await self.authenticationService.signUp(
//                    email: email,
//                    password: pass,
//                    name: name
//                )
//            default:
//                return
//            }
//        }
    }

    func forgotPassword() {
        // TODO: Handle forgot password
    }

    func signInWithGoogle() {
        // TODO: Handle Google sign in
        // This is not supported at the moment, and this action should trigger an alert
        // for notifying the user.
    }

    func signInWithApple() {
        // TODO: Handle Apple sign in.
        // This is not supported at the moment, and this action should trigger an alert
        // for notifying the user.
    }
}
