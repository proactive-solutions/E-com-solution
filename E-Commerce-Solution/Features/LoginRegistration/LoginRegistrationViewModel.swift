//
//  LoginRegistrationViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Combine
import DataModels
import Foundation
import ValidationKit

@MainActor
final class LoginRegistrationViewModel: ObservableObject {
    enum Mode {
        case login
        case signUp
    }

    // MARK: Published properties

    @Published var userEmail = ""
    @Published var userPassword = ""
    @Published var userMobileNumber = ""
    @Published var userName = ""
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var selectedMode = Mode.login
    @Published var emailValidationError: String?
    @Published var passwordValidationError: String?
    @Published var nameValidationError: String?

    // MARK: Private properties

    private var email: Result<EmailAddress, Validator.EmailValidationError>?
    private var name: Result<Name, Validator.NameValidationError>?
    private var password: Result<Password, Validator.PasswordValidationError>?

    private var cancellables = Set<AnyCancellable>()

    lazy var authenticationService = AuthenticationService()

    init() {
        validateEmailInput()
        validatePasswordInput()
        validateNameInput()
    }

    fileprivate func validateEmailInput() {
        let emailSub = $userEmail
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .compactMap { t -> Result<DataModels.EmailAddress, Validator.EmailValidationError>? in
                do {
                    let e = try DataModels.EmailAddress(t)
                    return .success(e)
                } catch let error as Validator.EmailValidationError {
                    return .failure(error)
                } catch {
                    return nil
                }
            }
            .eraseToAnyPublisher()
            .sink { [weak self] result in
                guard let self else { return }
                self.email = result
                if case let .failure(reason) = self.email {
                    emailValidationError = self.emailErrorDescription(result: reason)
                } else {
                    emailValidationError = nil
                }
            }

        cancellables.insert(emailSub)
    }

    fileprivate func validatePasswordInput() {
        let passwordSub = $userPassword
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .compactMap { t -> Result<DataModels.Password, Validator.PasswordValidationError>? in
                do {
                    let e = try DataModels.Password(t)
                    return .success(e)
                } catch let error as Validator.PasswordValidationError {
                    return .failure(error)
                } catch {
                    return nil
                }
            }
            .eraseToAnyPublisher()
            .sink { [weak self] result in
                guard let self else { return }
                self.password = result
                if case let .failure(reason) = self.password {
                    passwordValidationError = self.passwordErrorDescription(result: reason)
                } else {
                    passwordValidationError = nil
                }
            }
        cancellables.insert(passwordSub)
    }

    fileprivate func validateNameInput() {
        let userNameSub = $userName
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .compactMap { t -> Result<DataModels.Name, Validator.NameValidationError>? in
                do {
                    let e = try DataModels.Name(t)
                    return .success(e)
                } catch let error as Validator.NameValidationError {
                    return .failure(error)
                } catch {
                    return nil
                }
            }
            .eraseToAnyPublisher()
            .sink { [weak self] result in
                guard let self else { return }
                self.name = result
                if case let .failure(reason) = self.name {
                    nameValidationError = self.nameErrorDescription(result: reason)
                } else {
                    nameValidationError = nil
                }
            }

        cancellables.insert(userNameSub)
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
        case let .invalidPassword(requirements):
            NSLocalizedString(requirements.description, comment: "")
        }
    }

    // MARK: - Actions

    func signIn() {
        Task { [weak self] in
            guard let self else { return }
            self.isLoading = true
            defer { self.isLoading = false }
            guard let email = self.email, let password = self.password else { return }
            // Need to proceed in case of valid email, and password only.
            // For any other case authentication cannot be done.
            switch (email, password) {
            case let (.success(email), .success(pass)):
                await self.authenticationService.signIn(
                    email: email,
                    password: pass
                )
            default:
                return
            }
        }
    }

    func signup() {
        Task { [weak self] in
            guard
                let self,
                let email = self.email,
                let password = self.password,
                let name = self.name
            else { return }
            self.isLoading = true
            defer { self.isLoading = false }
            // Need to proceed in case of valid email, and password only.
            // For any other case authentication cannot be done.
            switch (email, password, name) {
            case let (.success(email), .success(pass), .success(name)):
                await self.authenticationService.signUp(
                    email: email,
                    password: pass,
                    name: name
                )
            default:
                return
            }
        }
    }

    func forgotPassword() {
        // TODO: Handle forgot password
    }

    func signInWithGoogle() {
        // TODO: Handle Google sign in
        // This is not supported at the moment, and this action should trigger an alert
        // for notifying the user.
    }

    func signInWithApple() {
        // TODO: Handle Apple sign in.
        // This is not supported at the moment, and this action should trigger an alert
        // for notifying the user.
    }
}
