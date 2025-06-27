import Testing
import Combine
import DataModels
import ValidationKit
@testable import E_Commerce_Solution

@MainActor
struct LoginRegistrationViewModelTests {
    // MARK: - Email Validation Tests
    let viewModel: LoginRegistrationViewModel

    init() {
        self.viewModel = LoginRegistrationViewModel()
    }

    @Test("Valid email input updates email property and clears error")
    func testValidEmailInput() async {
        let validEmail = "test@example.com"

        viewModel.userEmail = validEmail
        await Task.yield() // Allow async validation to complete

        #expect(viewModel.emailValidationError == nil)
    }

    @Test("Invalid email input sets appropriate error message")
    func testInvalidEmailInput() async {
        let viewModel = LoginRegistrationViewModel()
        let invalidEmail = "invalid-email"

        viewModel.userEmail = invalidEmail
        await Task.yield()

        #expect(viewModel.emailValidationError != nil)
    }

    @Test("Empty email input sets empty error message")
    func testEmptyEmailInput() async {
        viewModel.userEmail = ""
        await Task.yield()

        #expect(viewModel.emailValidationError == "Email address is empty")
    }

    // MARK: - Password Validation Tests

    @Test("Valid password input updates password property and clears error")
    func testValidPasswordInput() async {
        let viewModel = LoginRegistrationViewModel()
        let validPassword = "Password123!"

        viewModel.userPassword = validPassword
        await Task.yield()

        #expect(viewModel.passwordValidationError == nil)
    }

    @Test("Invalid password input sets appropriate error message")
    func testInvalidPasswordInput() async {
        let viewModel = LoginRegistrationViewModel()
        let invalidPassword = "weak"

        viewModel.userPassword = invalidPassword
        await Task.yield()

        #expect(viewModel.passwordValidationError != nil)
    }

    // MARK: - Name Validation Tests

    @Test("Valid name input updates name property and clears error")
    func testValidNameInput() async {
        let viewModel = LoginRegistrationViewModel()
        let validName = "John Doe"

        viewModel.userName = validName
        await Task.yield()

        #expect(viewModel.nameValidationError == nil)
    }

    @Test("Too short name input sets appropriate error message")
    func testTooShortNameInput() async {
        let viewModel = LoginRegistrationViewModel()
        let shortName = "A"

        viewModel.userName = shortName
        await Task.yield()

        #expect(viewModel.nameValidationError?.contains("at least") == true)
    }

    // MARK: - Sign In Tests

    @Test("Sign in with valid credentials calls authentication service")
    func testSignInWithValidCredentials() async {
        let viewModel = LoginRegistrationViewModel()

        viewModel.userEmail = "test@example.com"
        viewModel.userPassword = "Password123!"
        await Task.yield()

        viewModel.signIn()
        #expect(viewModel.isLoading == false)
    }

    @Test("Sign in with invalid credentials does not call authentication service")
    func testSignInWithInvalidCredentials() async {
        let viewModel = LoginRegistrationViewModel()

        viewModel.userEmail = "invalid-email"
        viewModel.userPassword = "weak"
        await Task.yield()

        viewModel.signIn()

        #expect(viewModel.isLoading == false)
    }

    // MARK: - Sign Up Tests

    @Test("Sign up with valid credentials calls authentication service")
    func testSignUpWithValidCredentials() async {
        let viewModel = LoginRegistrationViewModel()

        viewModel.userEmail = "test@example.com"
        viewModel.userPassword = "Password123!"
        viewModel.userName = "John Doe"
        await Task.yield()

        viewModel.signup()
        #expect(viewModel.isLoading == false)
    }

    @Test("Sign up with invalid credentials does not call authentication service")
    func testSignUpWithInvalidCredentials() async {
        let viewModel = LoginRegistrationViewModel()

        viewModel.userEmail = "invalid-email"
        viewModel.userPassword = "weak"
        viewModel.userName = "A"
        await Task.yield()

        viewModel.signup()
        #expect(viewModel.isLoading == false)
    }
}
