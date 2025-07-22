//
//  EmailAddress.swift
//  Models
//
//  Created by Pawan Sharma on 12/06/2025.
//
import ValidationKit

public struct Password: Equatable {
    public var value: String

    public init(
        _ value: String,
        specialCharacters: String = Validator.defaultSpecialCharacters,
        requirements: Set<Validator.PasswordValidationRequirement> = Validator.defaultPasswordRequirements
    ) throws(Validator.PasswordValidationError) {
        let result = Validator.validate(
            password: value,
            against: requirements,
            specialCharacters: specialCharacters
        )
        switch result {
        case .success:
            self.value = value

        case let .failure(reason):
            throw reason
        }
    }
}
