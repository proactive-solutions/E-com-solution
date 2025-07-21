//
//  AuthenticationService.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 24/06/2025.
//

import DataModels
@preconcurrency import FirebaseAuth
import FirebaseCore
import SwiftUI

@MainActor
final class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var authStateListener: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthStateListener()
    }

    deinit {
        MainActor.assumeIsolated {
            removeAuthStateListener()
        }
    }

    // MARK: - Private Methods

    private func setupAuthStateListener() {
        authStateListener = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _, user in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
    }

    private func removeAuthStateListener() {
        guard let listener = authStateListener else { return }
        Auth.auth().removeStateDidChangeListener(listener)
    }

    private func mapErrorToMessage(_ error: any Error) -> String {
        guard let authError = error as NSError? else {
            return "An unknown error has occurred. Please try again later"
        }
        return switch AuthErrorCode(rawValue: authError.code) {
        case .emailAlreadyInUse: "Email is already in use"
        case .invalidEmail     : "Invalid email address"
        case .weakPassword     : "Password is too weak"
        case .userNotFound     : "User not found"
        case .wrongPassword    : "Incorrect password"
        case .invalidCredential: "Invalid login credentials provided"
        default                : authError.localizedDescription
        }
    }

    // MARK: - Public Authentication Methods

    func signUp(
        email: DataModels.EmailAddress,
        password: DataModels.Password,
        name: DataModels.Name
    ) async {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email.value,
                password: password.value
            )
            user = result.user
            errorMessage = nil
            // Update the user profile with display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = name.value
            try await changeRequest.commitChanges()
        } catch {
            errorMessage = mapErrorToMessage(error)
        }
    }

    func signIn(
        email: DataModels.EmailAddress,
        password: DataModels.Password
    ) async {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email.value,
                password: password.value
            )
            user = result.user
            errorMessage = nil
        } catch {
            errorMessage = mapErrorToMessage(error)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            errorMessage = mapErrorToMessage(error)
        }
    }

    func resetPassword(email: DataModels.EmailAddress) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email.value)
            errorMessage = "Password reset email sent"
        } catch {
            errorMessage = mapErrorToMessage(error)
        }
    }

    func deleteAccount() async {
        guard let currentUser = Auth.auth().currentUser else { return }

        do {
            try await currentUser.delete()
            errorMessage = nil
        } catch {
            errorMessage = mapErrorToMessage(error)
        }
    }
}
