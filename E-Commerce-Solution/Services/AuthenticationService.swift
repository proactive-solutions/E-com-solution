//
//  AuthenticationService.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 24/06/2025.
//

import DataModels
import FirebaseAuth
import FirebaseCore
import SwiftUI

final class AuthenticationService: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private var authStateListener: AuthStateDidChangeListenerHandle?

    init() {
        setupAuthStateListener()
    }

    deinit {
        removeAuthStateListener()
    }

    // MARK: - Private Methods

    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            self?.isAuthenticated = user != nil
        }
    }

    private func removeAuthStateListener() {
        guard let listener = authStateListener else { return }
        Auth.auth().removeStateDidChangeListener(listener)
    }

    private func handleAuthError(_ error: Error) {
        if let authError = error as NSError? {
            switch AuthErrorCode(rawValue: authError.code) {
            case .emailAlreadyInUse:
                errorMessage = "Email is already in use"
            case .invalidEmail:
                errorMessage = "Invalid email address"
            case .weakPassword:
                errorMessage = "Password is too weak"
            case .userNotFound:
                errorMessage = "User not found"
            case .wrongPassword:
                errorMessage = "Incorrect password"
            default:
                errorMessage = authError.localizedDescription
            }
        }
    }

    // MARK: - Public Authentication Methods

    func signUp(email: DataModels.EmailAddress, password: DataModels.Password) async {
        do {
            let result = try await Auth.auth().createUser(
                withEmail: email.value,
                password: password.value
            )
            user = result.user
            errorMessage = nil
        } catch {
            handleAuthError(error)
        }
    }

    func signIn(email: DataModels.EmailAddress, password: DataModels.Password) async {
        do {
            let result = try await Auth.auth().signIn(
                withEmail: email.value,
                password: password.value
            )
            user = result.user
            errorMessage = nil
        } catch {
            handleAuthError(error)
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            handleAuthError(error)
        }
    }

    func resetPassword(email: DataModels.EmailAddress) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email.value)
            errorMessage = "Password reset email sent"
        } catch {
            handleAuthError(error)
        }
    }

    func deleteAccount() async {
        guard let currentUser = Auth.auth().currentUser else { return }

        do {
            try await currentUser.delete()
            errorMessage = nil
        } catch {
            handleAuthError(error)
        }
    }
}
