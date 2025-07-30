//
//  AuthError.swift
//  DataModels
//
//  Created by Pawan Sharma on 30/07/2025.
//

public enum AuthError: Error, Equatable, Sendable {
  case invalidEmail
  case wrongPassword
  case userNotFound
  case emailAlreadyInUse
  case weakPassword
  case networkError
  case unknown(String)

  public var localizedDescription: String {
    switch self {
    case .invalidEmail     : "Invalid email address"
    case .wrongPassword    : "Incorrect password"
    case .userNotFound     : "No account found with this email"
    case .emailAlreadyInUse: "Email address is already in use"
    case .weakPassword     : "Password is too weak"
    case .networkError     : "Network error occurred"
    case let .unknown(msg) : msg
    }
  }
}
