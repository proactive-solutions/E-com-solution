//
//  LoginViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Foundation
import Models
import ValidationKit

// MARK: - Supporting Types

final class LoginRegistrationViewModel: ObservableObject {
    enum Mode {
        case login
        case signUp
    }
    @Published var email: Result<EmailAddress, Validator.EmailValidationError>? {
        willSet {
            switch newValue {
            case .failure(let reason):
                emailValidationError = emailErrorDescription(result: reason)
            case .none, .some(.success):
                emailValidationError = nil
                break
            }
        }
    }
    @Published var name: Result<Name, Validator.NameValidationError>? {
        willSet {
            switch newValue {
            case .failure(let reason):
                nameValidationError = nameErrorDescription(result: reason)
            case .none, .some(.success):
                nameValidationError = nil
                break
            }
        }
    }
    @Published var password: Result<Password, Validator.PasswordValidationError>? {
        willSet {
            switch newValue {
            case .failure(let reason):
                passwordValidationError = passwordErrorDescription(result: reason)
            case .none, .some(.success):
                passwordValidationError = nil
                break
            }
        }
    }
    @Published var mobileNumber: Result<MobileNumber, Validator.MobileNumberValidationError>? {
        willSet {
            switch newValue {
            case .failure(let reason):
                mobileNumberValidationError = mobileErrorDescription(result: reason)
            case .none, .some(.success):
                mobileNumberValidationError = nil
                break
            }
        }
    }
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var selectedMode = Mode.login
    @Published var emailValidationError: String?
    @Published var passwordValidationError: String?
    @Published var nameValidationError: String?
    @Published var mobileNumberValidationError: String?

    func set(email: String) {
        do {
            let _email = try EmailAddress(email)
            self.email = .success(_email)
        } catch let error as Validator.EmailValidationError {
            // TODO: Handle the error here for email validation failure
            self.email = .failure(error)
        } catch {
            print("Unknown Error: ", error.localizedDescription)
        }
    }

    func set(name: String) {
        do {
            let _name = try Name(name)
            self.name = .success(_name)
        } catch let error as Validator.NameValidationError {
            // TODO: Handle the error here for Name validation failure
            self.name = .failure(error)
        } catch {
            print("Unknown Error: ", error.localizedDescription)
        }
    }

    func set(mobileNumber: String) {
        do {
            let _mobileNumber = try MobileNumber(mobileNumber)
            self.mobileNumber = .success(_mobileNumber)
        } catch let error as Validator.MobileNumberValidationError {
            self.mobileNumber = .failure(error)
        } catch {
            // TODO: Handle the error here for mobile number validation failure
            print("Unknown Error: ", error.localizedDescription)
        }
    }

    func set(password: String) {
        do {
            let _password = try Password(password)
            self.password = .success(_password)
        } catch let error as Validator.PasswordValidationError {
            self.password = .failure(error)
        } catch {
            // TODO: Handle the error here for mobile number validation failure
            print("Unknown Error: ", error.localizedDescription)
        }
    }

    func emailErrorDescription(
        result: Validator.EmailValidationError
    ) -> String {
        return switch result {
        case .empty: NSLocalizedString("Email address is empty", comment: "")
        case .invalidEmailAddress: NSLocalizedString("Invalid email address", comment: "")
        }
    }

    func nameErrorDescription(
        result: Validator.NameValidationError
    ) -> String {
        return switch result {
        case .invalidCharacters:
            NSLocalizedString("Name contains invalid characters", comment: "")

        case let .tooLong(maximum: length):
            NSLocalizedString("Name should not be longer than \(length) characters", comment: "")

        case let .tooShort(minimum: length):
            NSLocalizedString("Name should be at least \(length) characters long", comment: "")
        }
    }

    func mobileErrorDescription(
        result: Validator.MobileNumberValidationError
    ) -> String {
        switch result {
        case .invalidMobileNumber:
            NSLocalizedString("Mobile number is invalid", comment: "")
        }
    }

    func passwordErrorDescription(
        result: Validator.PasswordValidationError
    ) -> String {
        switch result {
        case .invalidPassword(let requirements):
            NSLocalizedString(requirements.description, comment: "")
        }
    }

    // MARK: - Actions

    func signIn() {
        // TODO: Handle sign in
    }

    func forgotPassword() {
        // TODO: Handle forgot password
    }

    func signInWithGoogle() {
        // TODO: Handle Google sign in
    }

    func signInWithApple() {
        // TODO: Handle Apple sign in
    }
}
