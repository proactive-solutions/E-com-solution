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
  var signIn: @Sendable (
    DataModels.EmailAddress,
    DataModels.Password) async -> Result<AuthUser, AuthError>
  var signUp: @Sendable (
    DataModels.EmailAddress,
    DataModels.Password,
    DataModels.Name) async -> Result<AuthUser, AuthError>
  var signOut: @Sendable () async -> Result<Void, AuthError>
  var authStateStream: @Sendable () -> AsyncStream<AuthUser?>
  var getCurrentUser: @Sendable () -> AuthUser?
}

// MARK: - Live Implementation

extension FirebaseAuthClient {
  static let live = FirebaseAuthClient(
    signIn: { email, password in
      await withCheckedContinuation { continuation in
        Auth
          .auth()
          .signIn(withEmail: email.value, password: password.value) { result, error in
            if let error = error {
              continuation
                .resume(returning: .failure(AuthError(from: error)))
            } else if let user = result?.user {
              continuation
                .resume(returning: .success(AuthUser(from: user)))
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
            if let error = error {
              continuation
                .resume(returning: .failure(AuthError(from: error)))
            } else if let user = result?.user {
              // Set display name after creating user
              let changeRequest = user.createProfileChangeRequest()
              changeRequest.displayName = name.value
              changeRequest.commitChanges { error in
                if let error = error {
                  continuation
                    .resume(returning: .failure(AuthError(from: error)))
                } else {
                  continuation
                    .resume(returning: .success(AuthUser(from: user)))
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
        } catch {
          continuation
            .resume(returning: .failure(AuthError(from: error)))
        }
      }
    },

    authStateStream: {
      AsyncStream { continuation in
        let handle = Auth
          .auth()
          .addStateDidChangeListener { _, user in
            let authUser = user.map(AuthUser.init)
            continuation.yield(authUser)
          }

        continuation.onTermination = { _ in
          Auth.auth().removeStateDidChangeListener(handle)
        }
      }
    },

    getCurrentUser: {
      guard let user = Auth.auth().currentUser else { return nil }
      return AuthUser(from: user)
    })
}

// MARK: - Test Implementation

extension FirebaseAuthClient {
  static let test = FirebaseAuthClient(
    signIn: { email, password in
      // Simulate network delay
      try? await Task.sleep(for: .milliseconds(500))

      // Mock validation
      if email.value == "test@example.com", password.value == "password123" {
        return .success(AuthUser(
          uid: "test-uid",
          email: email.value,
          displayName: "Test User",
          isEmailVerified: true))
      } else {
        return .failure(.wrongPassword)
      }
    },

    signUp: { email, _, name in
      try? await Task.sleep(for: .milliseconds(500))

      if email.value == "existing@example.com" {
        return .failure(.emailAlreadyInUse)
      }

      return .success(
        AuthUser(
          uid: "new-user-uid",
          email: email.value,
          displayName: name.value,
          isEmailVerified: false))
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
    })
}

// MARK: - AuthUser Extension for Testing

extension AuthUser {
  init(
    uid: String,
    email: String?,
    displayName: String?,
    isEmailVerified: Bool)
  {
    self.uid = uid
    self.email = email
    self.displayName = displayName
    self.isEmailVerified = isEmailVerified
  }
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
