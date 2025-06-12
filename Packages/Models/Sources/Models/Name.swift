//
//  FullName.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct Name {
  public let value: String

  public init(_ value: String) throws {
    let result = Validator.validate(name: value)
    guard result == .validName else {
      throw result
    }
    self.value = value
  }
}
