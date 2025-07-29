//
//  FirebaseAuthFeature.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
import FirebaseAuth
import Foundation

@Reducer
struct FirebaseAuthFeature {
  @ObservableState
  struct State: Equatable {
    var isLoading = false
    var currentUser: AuthUser?
    var errorMessage: String?
    var showErrorAlert = false

    // Computed properties
    var isSignedIn: Bool {
      currentUser != nil
    }
  }

  enum Action {
    case signIn(
      email: DataModels.EmailAddress,
      password: DataModels.Password)
    case signUp(
      email: DataModels.EmailAddress,
      password: DataModels.Password,
      name: DataModels.Name)
    case signOut
    case authStateChanged(AuthUser?)
    case authResponse(Result<AuthUser, AuthError>)
    case dismissErrorAlert
    case startListeningToAuthState
    case stopListeningToAuthState
  }

  @Dependency(\.firebaseAuthClient) var firebaseAuthClient

  private enum CancelID { case authStateListener }

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .signIn(email, password):
        state.isLoading = true

        return .run { send in
          let result = await firebaseAuthClient
            .signIn(email, password)
          await send(.authResponse(result))
        }

      case let .signUp(email, password, name):
        state.isLoading = true

        return .run { send in
          let result = await firebaseAuthClient
            .signUp(email, password, name)
          await send(.authResponse(result))
        }

      case .signOut:
        state.isLoading = true

        return .run { _ in
          let result = await firebaseAuthClient.signOut()
          // await send(.authResponse(result.map { _ in nil as AuthUser? }.mapError { $0 }))
        }

      case let .authStateChanged(user):
        state.currentUser = user
        state.isLoading = false
        return .none

      case let .authResponse(result):
        state.isLoading = false

        switch result {
        case let .success(user):
          state.currentUser = user
          state.errorMessage = nil

        case let .failure(error):
          state.errorMessage = error.localizedDescription
          state.showErrorAlert = true
        }

        return .none

      case .dismissErrorAlert:
        state.showErrorAlert = false
        state.errorMessage = nil
        return .none

      case .startListeningToAuthState:
        return .run { send in
          for await user in firebaseAuthClient.authStateStream() {
            await send(.authStateChanged(user))
          }
        }
        .cancellable(id: CancelID.authStateListener)

      case .stopListeningToAuthState:
        return .cancel(id: CancelID.authStateListener)
      }
    }
  }
}

// MARK: - Auth User Model

struct AuthUser: Equatable {
  let uid: String
  let email: String?
  let displayName: String?
  let isEmailVerified: Bool

  init(from firebaseUser: User) {
    uid = firebaseUser.uid
    email = firebaseUser.email
    displayName = firebaseUser.displayName
    isEmailVerified = firebaseUser.isEmailVerified
  }
}

// MARK: - Auth Error

enum AuthError: Error, Equatable {
  case invalidEmail
  case wrongPassword
  case userNotFound
  case emailAlreadyInUse
  case weakPassword
  case networkError
  case unknown(String)

  var localizedDescription: String {
    switch self {
    case .invalidEmail      : "Invalid email address"
    case .wrongPassword     : "Incorrect password"
    case .userNotFound      : "No account found with this email"
    case .emailAlreadyInUse : "Email address is already in use"
    case .weakPassword      : "Password is too weak"
    case .networkError      : "Network error occurred"
    case let .unknown(msg)  : msg
    }
  }

  init(from firebaseError: any Error) {
    guard let authError = firebaseError as NSError? else {
      self = .unknown(firebaseError.localizedDescription)
      return
    }

    switch AuthErrorCode(rawValue: authError.code) {
    case .invalidEmail:
      self = .invalidEmail
    case .wrongPassword:
      self = .wrongPassword
    case .userNotFound:
      self = .userNotFound
    case .emailAlreadyInUse:
      self = .emailAlreadyInUse
    case .weakPassword:
      self = .weakPassword
    case .networkError:
      self = .networkError
    default:
      self = .unknown(authError.localizedDescription)
    }
  }
}
