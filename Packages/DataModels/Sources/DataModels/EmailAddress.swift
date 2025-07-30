//
//  EmailAddress.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct EmailAddress: Equatable, Sendable {
  public var value: String

  public init(_ value: String) throws(Validator.EmailValidationError) {
    switch Validator.validate(email: value) {
    case .success:
      self.value = value

    case let .failure(reason):
      throw reason
    }
  }
}
