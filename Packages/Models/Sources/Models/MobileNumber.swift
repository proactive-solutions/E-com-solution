//
//  MobileNumber.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit
public struct MobileNumber {
  public let value: String
  public init(_ value: String) throws {
    guard value.count == 10 else { throw Validator.EmailValidationResult.empty }
        self.value = value
    }
}
