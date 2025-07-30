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
