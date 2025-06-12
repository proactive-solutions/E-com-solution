//
//  EmailAddress.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct EmailAddress {
    public let value: String

    public init(_ value: String) throws {
      let result = Validator.validate(email: value)
      guard result == .validEmail else {
        throw result
      }
      self.value = value
    }
}
