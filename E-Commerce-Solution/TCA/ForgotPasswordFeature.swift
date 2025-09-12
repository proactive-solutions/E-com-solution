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
    var forgotPasswordEmail = ""
    var forgotPasswordLoading = false
    var isSuccess = false
    var isLoading = false
    var forgotPasswordSuccess = false
    var forgotPasswordMessage: String?

    var isForgotPasswordEmailValid: Bool {
      switch Validator.validate(email: forgotPasswordEmail) {
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
  }

  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .forgotPasswordEmailChanged(email):
        state.forgotPasswordEmail = email.lowercased().trimmingCharacters(in: .whitespaces)
        return .none

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
}
