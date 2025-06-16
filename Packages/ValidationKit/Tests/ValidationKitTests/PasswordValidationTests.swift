@testable import ValidationKit
import XCTest

private typealias PasswordPolicy = Set<Validator.PasswordValidationRequirement>

final class PasswordValidatorTests: XCTestCase {
    // Test basic valid password
    func testValidPassword() {
        let requirements: PasswordPolicy = [
            .minLength(8),
            .uppercaseLetters(1),
            .lowercaseLetters(1),
            .digits(1),
            .specialCharacters(1),
        ]
        let passwordUnderTest = "Passw0rd!"
        let result = Validator.validate(
            password: passwordUnderTest,
            against: requirements
        )

        XCTAssertNoThrow(
            try result.get(),
            "\(passwordUnderTest) Should be a valid password for \(requirements)"
        )
    }

    // Test minimum length requirement
    func testMinLengthFailure() {
        let requirements: PasswordPolicy = [.minLength(8)]
        let result = Validator.validate(password: "Short1!", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to length")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.minLength(8)))
            }
        }
    }

    // Test maximum length requirement
    func testMaxLengthFailure() {
        let requirements: PasswordPolicy = [.maxLength(5)]
        let result = Validator.validate(password: "LongPassword", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to length")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.maxLength(5)))
            }
        }
    }

    // Test uppercase requirement
    func testUppercaseFailure() {
        let requirements: PasswordPolicy = [.uppercaseLetters(2)]
        let result = Validator.validate(password: "Passw0rd!", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to insufficient uppercase")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.uppercaseLetters(2)))
            }
        }
    }

    // Test lowercase requirement
    func testLowercaseFailure() {
        let requirements: PasswordPolicy = [.lowercaseLetters(5)]
        let result = Validator.validate(password: "TESTpass1!", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to insufficient lowercase")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.lowercaseLetters(5)))
            }
        }
    }

    // Test digits requirement
    func testDigitsFailure() {
        let requirements: PasswordPolicy = [.digits(2)]
        let result = Validator.validate(password: "Password1!", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to insufficient digits")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.digits(2)))
            }
        }

        // Test special characters requirement
        func testSpecialCharactersFailure() {
            let requirements: PasswordPolicy = [.specialCharacters(2)]
            let result = Validator.validate(password: "Password1!", against: requirements)

            switch result {
            case .success:
                XCTFail("Password should be invalid due to insufficient special characters")

            case let .failure(reason):
                switch reason {
                case let .invalidPassword(failures):
                    XCTAssertEqual(failures.count, 1)
                    XCTAssertTrue(failures.contains(.specialCharacters(2)))
                }
            }
        }
    }

    // Test no spaces requirement
    func testNoSpacesFailure() {
        let requirements: PasswordPolicy = [.noSpaces]
        let result = Validator.validate(password: "Pass word1!", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid due to space")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.noSpaces))
            }
        }
    }

    // Test multiple failures
    func testMultipleFailures() {
        let requirements: PasswordPolicy = [
            .minLength(8),
            .uppercaseLetters(2),
            .digits(2),
        ]

        let result = Validator.validate(password: "pass1", against: requirements)

        switch result {
        case .success:
            XCTFail("Password should be invalid")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 3)
                XCTAssertTrue(failures.contains(.minLength(8)))
                XCTAssertTrue(failures.contains(.uppercaseLetters(2)))
                XCTAssertTrue(failures.contains(.digits(2)))
            }
        }
    }

    // Test custom special characters
    func testCustomSpecialCharacters() {
        let requirements: PasswordPolicy = [.specialCharacters(1)]
        let customSpecialChars = "@#$"
        let result = Validator.validate(
            password: "Password1-",
            against: requirements,
            specialCharacters: customSpecialChars
        )

        switch result {
        case .success:
            XCTFail("Password should be invalid with custom special characters")

        case let .failure(reason):
            switch reason {
            case let .invalidPassword(failures):
                XCTAssertEqual(failures.count, 1)
                XCTAssertTrue(failures.contains(.specialCharacters(1)))
            }
        }
    }

    func testDefaultRequirements() {
        let result = Validator.validate(password: "Ashlesha@123")
        XCTAssertNoThrow(
            try result.get(),
            "Password is valid with default requirements"
        )
    }
}
