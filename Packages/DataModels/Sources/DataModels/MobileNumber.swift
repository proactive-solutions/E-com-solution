//
//  MobileNumber.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct MobileNumber: Equatable, Sendable {
  public let value: String
  public init(_ value: String) throws(Validator.MobileNumberValidationError) {
    switch Validator.validate(mobileNumber: value) {
    case .success:
      self.value = value

    case let .failure(reason):
      throw reason
    }
  }
}
