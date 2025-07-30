//
//  File.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 30/07/2025.
//

import FirebaseAuth
import DataModels
// MARK: - Auth Error

extension DataModels.AuthError {
  static func from(_ firebaseError: any Error) -> DataModels.AuthError {
    guard let authError = firebaseError as NSError? else {
      return .unknown(firebaseError.localizedDescription)
    }

    return switch AuthErrorCode(rawValue: authError.code) {
    case .invalidEmail     : .invalidEmail
    case .wrongPassword    : .wrongPassword
    case .userNotFound     : .userNotFound
    case .emailAlreadyInUse: .emailAlreadyInUse
    case .weakPassword     : .weakPassword
    case .networkError     : .networkError
    default                : .unknown(authError.localizedDescription)
    }
  }
}
