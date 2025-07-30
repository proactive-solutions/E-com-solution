//
//  FirebaseAuthClient.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 22/07/2025.
//

import ComposableArchitecture
import DataModels
@preconcurrency import FirebaseAuth
import Foundation

// MARK: - Firebase Auth Client Protocol

struct FirebaseAuthClient {
  let signIn: @Sendable (
    DataModels.EmailAddress,
    DataModels.Password
  ) async -> Result<DataModels.AuthUser, DataModels.AuthError>
  let signUp: @Sendable (
    DataModels.EmailAddress,
    DataModels.Password,
    DataModels.Name
  ) async -> Result<DataModels.AuthUser, DataModels.AuthError>
  let signOut: @Sendable () async -> Result<Void, DataModels.AuthError>
  let authStateStream: @Sendable () -> AsyncStream<DataModels.AuthUser?>
  let getCurrentUser: @Sendable () -> DataModels.AuthUser?
}

// MARK: - Live Implementation

extension FirebaseAuthClient {
  static let live = FirebaseAuthClient(
    signIn: { email, password in
      await withCheckedContinuation { continuation in
        Auth
          .auth()
          .signIn(withEmail: email.value, password: password.value) { result, error in
            if let signInError = error {
              continuation
                .resume(returning: .failure(DataModels.AuthError.from(signInError)))
            } else if let user = result?.user {
              continuation
                .resume(returning: .success(DataModels.AuthUser.from(user)))
            } else {
              continuation
                .resume(returning: .failure(.unknown("Unknown error occurred")))
            }
          }
      }
    },

    signUp: { email, password, name in
      await withCheckedContinuation { continuation in
        Auth
          .auth()
          .createUser(withEmail: email.value, password: password.value) { result, error in
            if let signupError = error {
              continuation
                .resume(returning: .failure(DataModels.AuthError.from(signupError)))
            } else if let firebaseUser = result?.user {
              // Set display name after creating user
              let changeRequest = firebaseUser.createProfileChangeRequest()
              changeRequest.displayName = name.value
              changeRequest.commitChanges { error in
                if let updateProfileError = error {
                  continuation
                    .resume(returning: .failure(DataModels.AuthError.from(updateProfileError)))
                } else {
                  continuation
                    .resume(returning: .success(DataModels.AuthUser.from(firebaseUser)))
                }
              }
            } else {
              continuation
                .resume(returning: .failure(.unknown("Unknown error occurred")))
            }
          }
      }
    },

    signOut: {
      await withCheckedContinuation { continuation in
        do {
          try Auth.auth().signOut()
          continuation
            .resume(returning: .success(()))
        } catch let signOutError {
          continuation
            .resume(returning: .failure(AuthError.from(signOutError)))
        }
      }
    },

    authStateStream: {
      AsyncStream { continuation in
        let handle = Auth
          .auth()
          .addStateDidChangeListener { _, user in
            let authUser = user.map(DataModels.AuthUser.from)
            continuation.yield(authUser)
          }

        continuation.onTermination = { _ in
          Auth.auth().removeStateDidChangeListener(handle)
        }
      }
    },

    getCurrentUser: {
      guard let firebaseUser = Auth.auth().currentUser else { return nil }
      return AuthUser.from(firebaseUser)
    }
  )
}

// MARK: - Test Implementation

extension FirebaseAuthClient {
  static let test = FirebaseAuthClient(
    signIn: { email, password in
      // Simulate network delay
      try? await Task.sleep(for: .milliseconds(500))

      // Mock validation
      if email.value == "test@example.com", password.value == "password123" {
        return .success(DataModels.AuthUser(
          uid: "test-uid",
          email: email.value,
          displayName: "Test User",
          isEmailVerified: true
        ))
      } else {
        return .failure(.wrongPassword)
      }
    },

    signUp: { email, _, name in
      try? await Task.sleep(for: .milliseconds(500))

      if email.value == "existing@example.com" {
        return .failure(.emailAlreadyInUse)
      }

      return .success(DataModels.AuthUser(
        uid: "new-user-uid",
        email: email.value,
        displayName: name.value,
        isEmailVerified: false
      ))
    },

    signOut: {
      try? await Task.sleep(for: .milliseconds(200))
      return .success(())
    },

    authStateStream: {
      AsyncStream { continuation in
        // Mock initial state
        continuation.yield(nil)

        continuation.onTermination = { _ in
          // Cleanup if needed
        }
      }
    },

    getCurrentUser: {
      nil // Mock: no user signed in initially
    }
  )
}
// MARK: - Dependency Registration

extension DependencyValues {
  var firebaseAuthClient: FirebaseAuthClient {
    get { self[FirebaseAuthClientKey.self] }
    set { self[FirebaseAuthClientKey.self] = newValue }
  }
}

private enum FirebaseAuthClientKey: DependencyKey {
  static let liveValue = FirebaseAuthClient.live
  static let testValue = FirebaseAuthClient.test
  static let previewValue = FirebaseAuthClient.test
}
