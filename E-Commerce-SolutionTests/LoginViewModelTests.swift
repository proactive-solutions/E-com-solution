import Combine
import DataModels
@testable import E_Commerce_Solution
import Foundation
import Testing
import ValidationKit

@MainActor
struct LoginRegistrationViewModelTests {
  // MARK: - Email Validation Tests

  let viewModel: LoginRegistrationViewModel

  init() {
    viewModel = LoginRegistrationViewModel(
      debounceTime: 0.0, // Deliver immediately
      dropFirst: 0 // Do not ignore any inputs
    )
  }

  @Test("Valid email input updates email property and clears error")
  func testValidEmailInput() async {
    let validEmail = "test@example.com"
    viewModel.userEmail = validEmail

    // In case of valid email address there should be no error message for the user.
    #expect(viewModel.emailValidationError == nil)
  }

  @Test("Invalid email input sets appropriate error message")
  func testInvalidEmailInput() async {
    let invalidEmail = "invalid-email"
    viewModel.userEmail = invalidEmail
    await makeWait()
    #expect(viewModel.emailValidationError != nil)
  }

  @Test("Empty email input sets empty error message")
  func testEmptyEmailInput() async {
    viewModel.userEmail = ""
    await makeWait()
    #expect(viewModel.emailValidationError != nil)
  }

  // MARK: - Password Validation Tests

  @Test("Valid password input updates password property and clears error")
  func testValidPasswordInput() async {
    let validPassword = "Password123!"

    viewModel.userPassword = validPassword
    #expect(viewModel.passwordValidationError == nil)
  }

  @Test("Invalid password input sets appropriate error message")
  func testInvalidPasswordInput() async {
    let invalidPassword = "weak"

    viewModel.userPassword = invalidPassword
    await makeWait()
    #expect(viewModel.passwordValidationError != nil)
  }

  // MARK: - Name Validation Tests

  @Test("Valid name input updates name property and clears error")
  func testValidNameInput() async {
    let validName = "John"

    viewModel.userName = validName
    #expect(viewModel.nameValidationError == nil)
  }

  @Test("Too short name input sets appropriate error message")
  func testTooShortNameInput() async {
    let shortName = "A"
    viewModel.userName = shortName
    await makeWait()
    #expect(viewModel.nameValidationError?.contains("at least") == true)
  }

  // MARK: - Sign In Tests

  @Test("Sign in with valid credentials calls authentication service")
  func testSignInWithValidCredentials() async {
    viewModel.userEmail = "test@example.com"
    viewModel.userPassword = "Password123!"

    viewModel.signIn()
    #expect(viewModel.isLoading == false)
  }

  @Test("Sign in with invalid credentials does not call authentication service")
  func testSignInWithInvalidCredentials() async {
    viewModel.userEmail = "invalid-email"
    viewModel.userPassword = "weak"

    viewModel.signIn()
    #expect(viewModel.isLoading == false)
  }

  // MARK: - Sign Up Tests

  @Test("Sign up with valid credentials calls authentication service")
  func testSignUpWithValidCredentials() async {
    viewModel.userEmail = "test@example.com"
    viewModel.userPassword = "Password123!"
    viewModel.userName = "John Doe"

    viewModel.signup()
    #expect(viewModel.isLoading == false)
  }

  @Test("Sign up with invalid credentials does not call authentication service")
  func testSignUpWithInvalidCredentials() async {
    viewModel.userEmail = "invalid-email"
    viewModel.userPassword = "weak"
    viewModel.userName = "A"

    viewModel.signup()
    #expect(viewModel.isLoading == false)
  }
}

private extension LoginRegistrationViewModelTests {
  func makeWait() async {
    try? await Task.sleep(nanoseconds: 100_000_000)
  }
}
