//
//   FirebaseAuthClient+Test.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 30/07/2025.
//

import ComposableArchitecture
import DataModels
@preconcurrency import FirebaseAuth
import Foundation

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
