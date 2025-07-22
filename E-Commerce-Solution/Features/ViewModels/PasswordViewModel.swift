//
//  PasswordViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//

import Combine
import DataModels
import Foundation
import ValidationKit

final class PasswordViewModel: ObservableObject {
    @Published var userPassword = ""
    @Published var passwordValidationError: String?
    @Published var isPasswordVisible = false

    private(set) var passwordResult: Result<Password, Validator.PasswordValidationError>?
    private let dropFirst: Int
    private let debounceTime: DispatchQueue.SchedulerTimeType.Stride
    private var cancellables = Set<AnyCancellable>()

    init(
        debounceTime: DispatchQueue.SchedulerTimeType.Stride = 0.3,
        dropFirst: Int = 1
    ) {
        self.debounceTime = debounceTime
        self.dropFirst = dropFirst
        validatePasswordInput()
    }

    private func validatePasswordInput() {
        $userPassword
            .debounce(for: debounceTime, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst(dropFirst)
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
                self.passwordResult = result
                if case let .failure(reason) = self.passwordResult {
                    passwordValidationError = self.passwordErrorDescription(result: reason)
                } else {
                    passwordValidationError = nil
                }
            }
            .store(in: &cancellables)
    }

    func passwordErrorDescription(result: Validator.PasswordValidationError) -> String {
        switch result {
        case let .invalidPassword(requirements):
            requirements.description.localize()
        }
    }
}
