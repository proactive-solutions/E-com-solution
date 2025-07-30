//
//  DataModels.AuthUser+FirebaseUser.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 30/07/2025.
//

import DataModels
import FirebaseAuth

// MARK: - AuthUser initialisation with Firebase user

extension DataModels.AuthUser {
  static func from(_ firebaseUser: User) -> DataModels.AuthUser {
    DataModels.AuthUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      isEmailVerified: firebaseUser.isEmailVerified
    )
  }
}
