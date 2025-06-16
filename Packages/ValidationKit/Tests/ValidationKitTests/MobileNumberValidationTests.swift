//
//  MobileNumberValidationTests.swift
//  ValidationKit
//
//  Created by Pawan Sharma on 10/03/2025.
//

import ValidationKit
import XCTest

final class MobileNumberValidationTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidUSPhoneNumbers() {
        let validUSNumbers = [
            "(555) 123-4567",
            "555-123-4567",
            "555.123.4567",
            "5551234567",
        ]

        for number in validUSNumbers {
            XCTAssertNoThrow(
                try Validator.validate(mobileNumber: number).get(),
                "Expected '\(number)' to be valid"
            )
        }
    }

    func testValidUKPhoneNumbers() {
        let validUKNumbers = [
            "+44 20 7946 0958",
            "+442079460958",
            "020 7946 0958",
            "+44 7911 123456",
            "+44 161 496 0000",
        ]

        for phoneNumber in validUKNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertNoThrow(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testValidIndianPhoneNumbers() {
        let validIndianNumbers = [
            "+91 98765 43210",
            "+91 8765432109",
            "+91 7654321098",
        ]

        for phoneNumber in validIndianNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertNoThrow(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testValidChinesePhoneNumbers() {
        let validChineseNumbers = [
            "+86 138 0013 8000",
            "+8613800138000",
            "+86 159 9999 9999",
        ]

        for phoneNumber in validChineseNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertNoThrow(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testValidGermanPhoneNumbers() {
        let validGermanNumbers = [
            "+49 30 12345678",
            "+493012345678",
            "030 12345678",
            "+49 89 1234567",
        ]

        for phoneNumber in validGermanNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertNoThrow(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testValidInternationalPhoneNumbers() {
        let validInternationalNumbers = [
            "+33 1 42 86 83 26", // France
            "+81 3 1234 5678", // Japan
            "+61 2 9374 4000", // Australia
            "+55 11 99999 9999", // Brazil
            "+7 495 123 45 67", // Russia
            "+82 2 123 4567", // South Korea
        ]

        for phoneNumber in validInternationalNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertNoThrow(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testEmptyAndWhitespaceNumbers() {
        let invalidNumbers = [
            "",
            " ",
            "   ",
            "\t",
            "\n",
            "  \t  \n  ",
        ]

        for phoneNumber in invalidNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testInvalidCharacters() {
        let invalidNumbers = [
            "abc-def-ghij",
            "555-abc-1234",
            "+1 555 abc 1234",
            "555@123#4567",
            "555*123*4567",
            "phone number",
            "call me maybe",
        ]

        for phoneNumber in invalidNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testTooShortNumbers() {
        let tooShortNumbers = [
            "123",
            "1234",
            "12345",
            "+1 123",
            "+44 12",
            "555",
        ]

        for phoneNumber in tooShortNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be valid"
            )
        }
    }

    func testTooLongNumbers() {
        let tooLongNumbers = [
            "123456789012345678901234567890",
            "+1 555 123 4567 8901 2345",
            "55512345678901234567890",
        ]

        for phoneNumber in tooLongNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }

    func testInvalidCountryCodes() {
        let invalidCountryCodeNumbers = [
            "+999 555 123 4567",
            "+1234 555 123 4567",
            "+99999 555 123 4567",
        ]

        for phoneNumber in invalidCountryCodeNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }

    func testMalformedNumbers() {
        let malformedNumbers = [
            "++1 555 123 4567",
            "+-1 555 123 4567",
            "+1 555 123 4567 ext 123",
            "1-800-FLOWERS",
            "555-CALL-NOW",
        ]

        for phoneNumber in malformedNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }

    func testExcessiveWhitespace() {
        let numbersWithWhitespace = [
            "  +1 555 123 4567  ",
            "\t+44 20 7946 0958\n",
        ]

        for phoneNumber in numbersWithWhitespace {
            let result = Validator.validate(mobileNumber: phoneNumber)
            // Assuming the validator handles whitespace trimming
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }

    func testMixedSeparators() {
        let mixedSeparatorNumbers = [
            "+1 (555) 123-4567",
            "+1.555.123.4567",
            "+1-555-123-4567",
        ]

        for phoneNumber in mixedSeparatorNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }

    func testSpecialCharacters() {
        let specialCharNumbers = [
            "\0",
            "555\0123\04567",
        ]

        for phoneNumber in specialCharNumbers {
            let result = Validator.validate(mobileNumber: phoneNumber)
            XCTAssertThrowsError(
                try result.get(),
                "Expected '\(phoneNumber)' to be invalid"
            )
        }
    }
}
