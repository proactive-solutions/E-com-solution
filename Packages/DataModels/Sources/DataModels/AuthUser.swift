//
//  AuthUser.swift
//  DataModels
//
//  Created by Pawan Sharma on 30/07/2025.
//

// MARK: - Auth User Model

public struct AuthUser: Equatable, Sendable {
    public let uid: String
    public let email: String?
    public let displayName: String?
    public let isEmailVerified: Bool

    public init(uid: String, email: String?, displayName: String?, isEmailVerified: Bool) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.isEmailVerified = isEmailVerified
    }
}
