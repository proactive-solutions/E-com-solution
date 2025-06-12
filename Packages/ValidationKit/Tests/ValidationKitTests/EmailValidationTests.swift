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
        XCTAssertEqual(
            Validator.validate(email: ""),
            .empty
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
            XCTAssertEqual(
                Validator.validate(email: email),
                .validEmail,
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
            XCTAssertEqual(
                Validator.validate(email: email),
                .invalidEmailAddress,
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
            XCTAssertEqual(
                Validator.validate(email: email),
                .invalidEmailAddress,
                "Expected \(email) to have invalid domain"
            )
        }
    }
}
