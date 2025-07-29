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

  func signIn(
    email _: DataModels.EmailAddress,
    password _: DataModels.Password)
  {
//        Task { @MainActor [weak self] in
//            guard let self else { return }
//            self.isLoading = true
//            defer { self.isLoading = false }
//            await self
//                .authenticationService
//                .signIn(email: email, password: password)
//        }
  }

  func signup(
    email _: DataModels.EmailAddress,
    password _: DataModels.Password,
    name _: DataModels.Name)
  {
//        Task { [weak self] in
//            guard let self else { return }
//            self.isLoading = true
//            defer { self.isLoading = false }
//
//            await self
//                .authenticationService
//                .signUp(email: email, password: password, name: name)
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
