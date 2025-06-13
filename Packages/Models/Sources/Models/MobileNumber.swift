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
    // TODO: apply the mobile number validation logic here
        self.value = value
    }
}
