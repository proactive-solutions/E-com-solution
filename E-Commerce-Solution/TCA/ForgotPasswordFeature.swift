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
    fileprivate(set) var forgotPasswordLoading = false
    fileprivate(set) var forgotPasswordSuccess = false
    fileprivate(set) var forgotPasswordMessage: String?
  }

  enum Action {
    case sendPasswordReset(String)
    case passwordResetResponse(Result<Void, AuthError>)
    case dismissForgotPasswordAlert
  }

  @Dependency(\.continuousClock) var clock
  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  private enum CancelID { case emailValidation }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .dismissForgotPasswordAlert:
        state.forgotPasswordMessage = nil
        return .none

      case let .sendPasswordReset(email):
        state.forgotPasswordLoading = true
        state.forgotPasswordMessage = nil

        return .run { send in
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
