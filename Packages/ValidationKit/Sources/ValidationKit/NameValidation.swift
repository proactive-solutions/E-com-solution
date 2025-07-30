//
//  NameValidation.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//

import Foundation

extension Validator.NameValidationError: Mappable {}
extension Validator.NameValidationError: Equatable {
  public static func == (
    lhs: Validator.NameValidationError,
    rhs: Validator.NameValidationError
  ) -> Bool {
    switch (lhs, rhs) {
    case let (.tooShort(len1), .tooShort(len2)): len1 == len2
    case let (.tooLong(len1), .tooLong(len2)): len1 == len2
    case (.invalidCharacters, .invalidCharacters): true
    default: false
    }
  }
}

public extension Validator {
  /// Validates a name string against length requirements and character constraints.
  ///
  /// This function validates a name by:
  /// 1. Trimming whitespace and newlines from the input
  /// 2. Checking if the trimmed name meets minimum and maximum length requirements
  /// 3. Verifying that the name contains only valid characters according to a predefined regex pattern
  ///
  /// - Example:
  ///   ```swift
  ///   let result = Validator.validate(name: "John Doe")
  ///   // Returns .validName
  ///
  ///   let result = Validator.validate(name: "A", minLength: 3)
  ///   // Returns .tooShort(minimum: 3)
  ///   ```
  ///
  /// - Parameters:
  ///   - name: The name string to validate
  ///   - minLength: The minimum acceptable length for the name after trimming. Defaults to 3.
  ///   - maxLength: The maximum acceptable length for the name after trimming. Defaults to 30.
  ///
  /// - Returns: A `NameValidationResult` indicating the validation status:
  ///   - `.validName`: The name meets all validation requirements
  ///   - `.tooShort(minimum:)`: The name is shorter than the minimum required length
  ///   - `.tooLong(maximum:)`: The name exceeds the maximum allowed length
  ///   - `.invalidCharacters`: The name contains characters that don't match the allowed pattern
  static func validate(
    name: String,
    minLength: UInt = 3,
    maxLength: UInt = 30
  ) -> Result<Void, NameValidationError> {
    let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    let trimmedNameLength = trimmedName.count

    if trimmedNameLength < minLength {
      return .failure(.tooShort(minimum: minLength))
    }

    if trimmedNameLength > maxLength {
      return .failure(.tooLong(maximum: maxLength))
    }

    let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
    return if namePredicate.evaluate(with: trimmedName) {
      .success(())
    } else {
      .failure(.invalidCharacters)
    }
  }
}
