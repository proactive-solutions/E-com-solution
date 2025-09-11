//
//  File.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 30/07/2025.
//
import ComposableArchitecture
import DataModels
@preconcurrency import FirebaseAuth
import Foundation

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

    sendPasswordReset: { email in
      await withCheckedContinuation { continuation in
        Auth
          .auth()
          .sendPasswordReset(withEmail: email) { error in
            if let resetError = error {
              continuation
                .resume(returning: .failure(DataModels.AuthError.from(resetError)))
            } else {
              continuation
                .resume(returning: .success(()))
            }
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
