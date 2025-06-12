//
//  NameValidationTests.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//

import ValidationKit
import XCTest

final class NameValidationTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidNames() {
        let validNames = [
            "James",
            "Mary",
            "John"
        ]

        for name in validNames {
            XCTAssertEqual(
                Validator.validate(name: name),
                .validName,
                "Expected '\(name)' to be valid"
            )
        }
    }

    // Test minimum length validation
    func testNameTooShort() {
        let shortNames = [
            "",
            "A",
            "Bo",
            "   ",
            "  A  "
        ]

        for name in shortNames {
            XCTAssertEqual(
                Validator.validate(name: name),
                .tooShort(minimum: 3),
                "Expected '\(name)' to be too short"
            )
        }
    }

    // Test maximum length validation
    func testNameTooLong() {
        let longName = String(repeating: "A", count: 31)
        XCTAssertEqual(
            Validator.validate(name: longName),
            .tooLong(maximum: 30),
            "Expected long name to exceed maximum length"
        )
    }

    // Test invalid characters
    func testInvalidCharacters() {
        let invalidNames = [
            "John123",
            "Mary#Smith",
            "User@Name",
            "Test$Name",
            "Name!Here"
        ]

        for name in invalidNames {
            XCTAssertEqual(
                Validator.validate(name: name),
                .invalidCharacters,
                "Expected '\(name)' to contain invalid characters"
            )
        }
    }

    // Test whitespace handling
    func testWhitespaceHandling() {
        XCTAssertEqual(
            Validator.validate(name: "   A   "),
            .tooShort(minimum: 3),
            "Expected trimmed short name to be invalid"
        )
    }

    // Test custom length parameters
    func testCustomLengthValidation() {
        XCTAssertEqual(
            Validator.validate(name: "Bob", minLength: 3, maxLength: 10),
            .validName,
            "Expected 'Bob' to be valid with custom minimum length"
        )

        XCTAssertEqual(
            Validator.validate(name: "Alexander", minLength: 3, maxLength: 7),
            .tooLong(maximum: 7),
            "Expected 'Alexander' to be too long with custom maximum length"
        )
    }
}
