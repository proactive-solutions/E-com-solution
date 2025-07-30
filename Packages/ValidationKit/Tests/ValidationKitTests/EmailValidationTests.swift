//
//  EmailValidationTests.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//

import ValidationKit
import XCTest

final class EmailValidationTests: XCTestCase {
  // Test cases grouped by validation category
  func testEmptyEmail() {
    XCTAssertThrowsError(
      try Validator.validate(email: "").get(),
      "passing the empty string, as an argument should cause the validation failure"
    )
  }

  func testValidEmails() {
    let validEmails = [
      "user@domain.com",
      "user.name@domain.com",
      "user+label@domain.com",
      "user@subdomain.domain.com",
    ]
    for email in validEmails {
      XCTAssertNoThrow(
        try Validator.validate(email: email).get(),
        "Expected \(email) to be valid"
      )
    }
  }

  func testInvalidFormats() {
    let invalidFormats = [
      "invalid.email@",
      "@invalid.com",
      "example@@domain.com",
      "example@domain.",
      "example@domain",
      "example@domain..com",
      "example@domain.com.",
      ".example@domain.com",
    ]

    for email in invalidFormats {
      XCTAssertThrowsError(
        try Validator.validate(email: email).get(),
        "Expected \(email) to have invalid format"
      )
    }
  }

  func testInvalidDomains() {
    let invalidDomains = [
      "example-domain.com",
      "user@domain@com",
      "user@.com",
    ]

    for email in invalidDomains {
      XCTAssertThrowsError(
        try Validator.validate(email: email).get(),
        "Expected \(email) to have invalid domain"
      )
    }
  }
}
