//
//  EmailAddress.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct EmailAddress: Equatable {
    public let value: String

    public init(_ value: String) throws {
        switch Validator.validate(email: value) {
        case .success:
            self.value = value

        case let .failure(reason):
            throw reason
        }
    }
}
