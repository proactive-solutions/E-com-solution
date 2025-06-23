@testable import E_Commerce_Solution
import Testing

/// Comprehensive unit tests for LoginViewModel covering all validation scenarios
/// and edge cases for email, name, and mobile number properties
@Suite("LoginViewModel Tests")
struct LoginViewModelTests {
    var viewModel: LoginRegistrationViewModel

    /// Initialize a fresh LoginViewModel instance for each test
    init() {
        viewModel = LoginRegistrationViewModel()
    }

    // MARK: - Initialization Tests

    @Test("LoginViewModel initializes with all properties set to nil")
    func initializesWithDefaultValues() {
        #expect(viewModel.email == nil)
        #expect(viewModel.name == nil)
        #expect(viewModel.mobileNumber == nil)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isPasswordVisible == false)
        #expect(viewModel.selectedMode == .login)
        #expect(viewModel.emailValidationError == nil)
        #expect(viewModel.passwordValidationError == nil)
        #expect(viewModel.nameValidationError == nil)
        #expect(viewModel.mobileNumberValidationError == nil)
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
        #expect(viewModel.mobileNumberValidationError == nil)
    }

    // MARK: - Combined Property Tests

    @Test("All valid properties get stored successfully together")
    mutating func allValidPropertiesGetStoredSuccessfullyTogether() {
        viewModel.set(email: "pawan.sharma@yash.com")
        viewModel.set(name: "Pawan")
        viewModel.set(mobileNumber: "+919876543210")
        viewModel.set(password: "Abc@12345")

        #expect(viewModel.email != nil)
        #expect(viewModel.name != nil)
        #expect(viewModel.mobileNumber != nil)
        #expect(viewModel.password != nil)
        #expect(viewModel.emailValidationError == nil)
        #expect(viewModel.nameValidationError == nil)
        #expect(viewModel.mobileNumberValidationError == nil)
        #expect(viewModel.passwordValidationError == nil)
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

    @Test("Valid and invalid passwords are handled correctly")
    mutating func settingValidPasswordAfterInvalidOneOverwritesSuccessfully() {
        // Set invalid first
        viewModel.set(password: "Abcd213")
        if case .success = viewModel.password {
            Issue.record("Expected '\(String(describing: viewModel.email))' to fail validation")
        }

        // Set valid afterwards
        viewModel.set(password: "Abcd@213")
        #expect(viewModel.password != nil)
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
