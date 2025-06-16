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
        let validNames = ["James", "Mary", "John"]

        for name in validNames {
            XCTAssertNoThrow(
                try Validator.validate(name: name).get(),
                "'\(name)' should be valid"
            )
        }
    }

    // Test minimum length validation
    func testNameTooShort() {
        let shortNames = [
            "",
            "A",
            "Bo",
            "   ", // Only whitespace
            "  A  ", // Single char with whitespace
            "\t\n", // Other whitespace characters
            "  AB  ", // Two chars with whitespace
        ]

        for name in shortNames {
            let result = Validator.validate(name: name)
            switch result {
            case .success:
                XCTFail("Expected '\(name)' to fail validation but it succeeded")
            case let .failure(error):
                XCTAssertEqual(
                    error,
                    .tooShort(minimum: 3),
                    "Expected '\(name)' to be too short, but got different error: \(error)"
                )
            }
        }
    }

    // Test maximum length validation
    func testNameTooLong() {
        let longName = String(repeating: "A", count: 31)
        let result = Validator.validate(name: name)
        switch result {
        case .success:
            XCTFail("Expected '\(name)' to fail validation but it succeeded")
        case let .failure(error):
            XCTAssertEqual(
                error,
                .tooLong(maximum: 30),
                "Expected '\(name)' to be too long, but got different error: \(error)"
            )
        }
    }

    // Test invalid characters
    func testInvalidCharacters() {
        let invalidNames = [
            "John123",
            "Mary#Smith",
            "User@Name",
            "Test$Name",
            "Name!Here",
        ]

        for name in invalidNames {
            let result = Validator.validate(name: name)
            switch result {
            case .success:
                XCTFail("Expected '\(name)' to fail validation but it succeeded")
            case let .failure(error):
                XCTAssertEqual(
                    error,
                    .invalidCharacters,
                    "Expected '\(name)' to contain invalid characters"
                )
            }
        }
    }

    // Test whitespace handling
    func testWhitespaceHandling() {
        let result = Validator.validate(name: "   A   ")
        switch result {
        case .success:
            XCTFail("Expected '\(name)' to fail validation but it succeeded")
        case let .failure(error):
            XCTAssertEqual(
                error,
                .tooShort(minimum: 3),
                "Expected '\(name)' to contain invalid characters"
            )
        }
    }

    // Test custom length parameters
    func testCustomLengthValidation() {
        var result = Validator.validate(name: "Bob", minLength: 3, maxLength: 10)
        XCTAssertNoThrow(try result.get(), "Expected 'Bob' to be valid with custom minimum length")

        result = Validator.validate(name: "Alexander", minLength: 3, maxLength: 7)
        XCTAssertThrowsError(try result.get(), "Expected 'Alexander' to be too long with custom maximum length")
    }
}
