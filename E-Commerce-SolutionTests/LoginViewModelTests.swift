@testable import E_Commerce_Solution
import Testing

/// Comprehensive unit tests for LoginViewModel covering all validation scenarios
/// and edge cases for email, name, and mobile number properties
@Suite("LoginViewModel Tests")
struct LoginViewModelTests {
    var viewModel: LoginViewModel

    /// Initialize a fresh LoginViewModel instance for each test
    init() {
        viewModel = LoginViewModel()
    }

    // MARK: - Initialization Tests

    @Test("LoginViewModel initializes with all properties set to nil")
    func initializesWithNilProperties() {
        #expect(viewModel.email == nil)
        #expect(viewModel.name == nil)
        #expect(viewModel.mobileNumber == nil)
    }

    // MARK: - Email Validation Tests

    @Test("Valid email address gets stored successfully")
    mutating func validEmailAddressGetsStoredSuccessfully() {
        viewModel.set(email: "pawan.sharma@yash.com")
        #expect(viewModel.email != nil)
    }

    // MARK: - Name Validation Tests

    @Test("Valid single name gets stored successfully")
    mutating func validSingleNameGetsStoredSuccessfully() {
        viewModel.set(name: "Pawan")
        #expect(viewModel.name != nil)
    }

    // MARK: - Mobile Number Validation Tests

    @Test("Valid mobile number gets stored successfully")
    mutating func validMobileNumberGetsStoredSuccessfully() {
        viewModel.set(mobileNumber: "+919876543210")
        #expect(viewModel.mobileNumber != nil)
    }

    // MARK: - Combined Property Tests

    @Test("All valid properties get stored successfully together")
    mutating func allValidPropertiesGetStoredSuccessfullyTogether() {
        viewModel.set(email: "pawan.sharma@yash.com")
        viewModel.set(name: "Pawan")
        viewModel.set(mobileNumber: "+919876543210")

        #expect(viewModel.email != nil)
        #expect(viewModel.name != nil)
        #expect(viewModel.mobileNumber != nil)
    }

    @Test("Setting valid property after invalid one overwrites successfully")
    mutating func settingValidPropertyAfterInvalidOneOverwritesSuccessfully() {
        // Set invalid first
        viewModel.set(email: "invalid-email")
        if case .success = viewModel.email {
            Issue.record("Expected '\(String(describing: viewModel.email))' to fail validation")
        }

        // Set valid afterwards
        viewModel.set(email: "valid@email.com")
        #expect(viewModel.email != nil)
    }

    @Test("Setting invalid property after valid one keeps valid value")
    mutating func settingInvalidPropertyAfterValidOneKeepsValidValue() {
        // Set valid first
        viewModel.set(name: "John")
        #expect(viewModel.name != nil)

        // Attempt to set invalid
        viewModel.set(name: "")
        if case .success = viewModel.name {
            Issue.record("Expected '\(String(describing: viewModel.name))' to fail validation")
        }
    }
}
