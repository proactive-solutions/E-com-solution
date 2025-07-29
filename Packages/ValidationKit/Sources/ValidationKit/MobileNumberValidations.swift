//
//  MobileNumberValidations.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 13/06/2025.
//

import PhoneNumberKit

extension Validator.MobileNumberValidationError: Mappable {}

public extension Validator {
  /// Validates a mobile phone number string.
  ///
  /// This method checks whether the provided mobile number string is valid according to
  /// international phone number formatting standards. The validation is performed using
  /// the `PhoneNumberUtility` which handles various country formats and number patterns.
  ///
  /// - Parameter mobileNumber: The mobile phone number string to validate.
  ///   The number can be in various formats including:
  ///   - International format: `+1 555 123 4567`
  ///   - National format: `(555) 123-4567`
  ///   - Raw digits: `15551234567`
  ///
  /// - Returns: A ``MobileNumberValidationResult`` indicating whether the number is valid or invalid.
  ///
  /// - Note: The validation process considers:
  ///   - Country code validity
  ///   - Number length requirements
  ///   - Digit pattern matching
  ///   - Regional formatting rules
  ///
  /// - Important: This method performs format validation only. It does not verify if the
  ///   number is currently active or reachable.
  ///
  /// ## Examples
  ///
  /// ### Valid Numbers
  /// ```swift
  /// // US number with country code
  /// let result1 = Validator.validate(mobileNumber: "+1 555 123 4567")
  /// // result1 == .valid
  ///
  /// // UK number
  /// let result2 = Validator.validate(mobileNumber: "+44 20 7946 0958")
  /// // result2 == .valid
  ///
  /// // Indian number
  /// let result3 = Validator.validate(mobileNumber: "+91 98765 43210")
  /// // result3 == .valid
  /// ```
  ///
  /// ### Invalid Numbers
  /// ```swift
  /// // Too short
  /// let result1 = Validator.validate(mobileNumber: "123")
  /// // result1 == .invalid
  ///
  /// // Invalid format
  /// let result2 = Validator.validate(mobileNumber: "abc-def-ghij")
  /// // result2 == .invalid
  ///
  /// // Empty string
  /// let result3 = Validator.validate(mobileNumber: "")
  /// // result3 == .invalid
  /// ```
  ///
  /// ## Performance Considerations
  ///
  /// - The validation process is lightweight and suitable for real-time validation
  /// - Consider caching results for frequently validated numbers
  /// - For bulk validation, consider using asynchronous processing
  ///
  /// ## Thread Safety
  ///
  /// This method is thread-safe and can be called from any queue.
  static func validate(mobileNumber: String) -> Result<Void, Validator.MobileNumberValidationError> {
    let utility = PhoneNumberUtility()
    return if utility.isValidPhoneNumber(mobileNumber) {
      .success(())
    } else {
      .failure(.invalidMobileNumber)
    }
  }
}
