//
//  ValidateEmail.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//
import Foundation

extension Validator.EmailValidationError: Mappable {}

public extension Validator {
  /// This validator checks if the provided string is a valid email address by:
  /// 1. Trimming whitespace and newlines
  /// 2. Checking if the result is empty
  /// 3. Validating against the RFC 5322 email format pattern
  /// - Parameter email: The email string to validate
  /// - Returns: An `EmailValidationResult` indicating whether the email is:
  ///   - `.empty`: The email string is empty after trimming
  ///   - `.validEmail`: The email string is a valid email address
  ///   - `.invalidEmailAddress`: The email string is not a valid email address
  static func validate(
    email: String
  ) -> Result<Void, EmailValidationError> {
    let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmedEmail.isEmpty {
      return .failure(.empty)
    }

    // Full RFC 5322 validation
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return if emailPredicate.evaluate(with: trimmedEmail) {
      .success(())
    } else {
      .failure(.invalidEmailAddress)
    }
  }
}
