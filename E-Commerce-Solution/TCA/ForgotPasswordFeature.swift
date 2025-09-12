//
//  ForgotPasswordFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 11/09/2025.
//

import ComposableArchitecture
import DataModels
import FirebaseAuth
import Foundation
import ValidationKit

@Reducer
struct ForgotPasswordFeature {
  struct State: Equatable {
    var forgotPasswordLoading = false
    var forgotPasswordSuccess = false
    var forgotPasswordMessage: String?
    var emailValidationError: String?
    var forgotPasswordEmail = ""
    fileprivate(set) var validatedEmailResult: Result<DataModels.EmailAddress, Validator.EmailValidationError>?

    var isForgotPasswordEmailValid: Bool {
      guard let result = validatedEmailResult else { return false }
      switch result {
      case .success: return true
      case .failure: return false
      }
    }
  }

  enum Action {
    case forgotPasswordEmailChanged(String)
    case sendPasswordReset
    case passwordResetResponse(Result<Void, AuthError>)
    case dismissForgotPasswordAlert
    case validateEmail
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  private enum CancelID { case emailValidation }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .validateEmail:
        return validateEmailEffect(state: &state)

      case let .forgotPasswordEmailChanged(email):
        state.forgotPasswordEmail = email.lowercased().trimmingCharacters(in: .whitespaces)

        // Debounce validation - wait 0.3 seconds after user stops typing
        return .run { send in
          try await clock.sleep(for: .milliseconds(300))
          await send(.validateEmail)
        }
        .cancellable(id: CancelID.emailValidation)

      case .dismissForgotPasswordAlert:
        state.forgotPasswordMessage = nil
        return .none

      case .sendPasswordReset:
        guard state.isForgotPasswordEmailValid else {
          state.forgotPasswordMessage = "Please enter a valid email address"
          return .none
        }

        state.forgotPasswordLoading = true
        state.forgotPasswordMessage = nil

        return .run { [email = state.forgotPasswordEmail] send in
          let result = await firebaseAuthClient.sendPasswordReset(email)
          await send(.passwordResetResponse(result))
        }

      case let .passwordResetResponse(result):
        state.forgotPasswordLoading = false

        switch result {
        case .success:
          state.forgotPasswordSuccess = true
          state.forgotPasswordMessage = "Password reset link has been sent to your email address. Please check your inbox and spam folder."

        case let .failure(error):
          state.forgotPasswordMessage = error.localizedDescription
        }

        return .none
      }
    }
  }

  private func validateEmailEffect(state: inout State) -> Effect<Action> {
    // Skip validation for empty text (don't show error immediately)
    guard !state.forgotPasswordEmail.isEmpty else {
      state.emailValidationError = nil
      state.validatedEmailResult = .failure(.empty)
      return .none
    }

    do {
      let validatedEmail = try EmailAddress(state.forgotPasswordEmail)
      state.emailValidationError = nil
      state.validatedEmailResult = .success(validatedEmail)
    } catch {
      // Email is invalid
      state.emailValidationError = emailErrorMessage(for: error)
      state.validatedEmailResult = .failure(error)
    }
    return .none
  }

  private func emailErrorMessage(for error: Validator.EmailValidationError) -> String {
    switch error {
    case .empty: "Email address is empty".localize()
    case .invalidEmailAddress: "Invalid email address".localize()
    }
  }
}
