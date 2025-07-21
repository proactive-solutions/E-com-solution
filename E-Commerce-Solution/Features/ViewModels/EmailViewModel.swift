//
//  EmailViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//

import Combine
import DataModels
import Foundation
import ValidationKit

final class EmailViewModel: ObservableObject {
    @Published var userEmail = ""
    @Published var emailValidationError: String?
    private(set) var email: Result<EmailAddress, Validator.EmailValidationError>?

    private let dropFirst: Int
    private let debounceTime: DispatchQueue.SchedulerTimeType.Stride
    private var cancellables = Set<AnyCancellable>()

    init(
        debounceTime: DispatchQueue.SchedulerTimeType.Stride = 0.3,
        dropFirst: Int = 1
    ) {
        self.debounceTime = debounceTime
        self.dropFirst = dropFirst
        validateEmailInput()
    }

    private func validateEmailInput() {
        let emailSub = $userEmail
            .debounce(for: debounceTime, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst(dropFirst)
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

    func emailErrorDescription(
        result: Validator.EmailValidationError
    ) -> String {
        return switch result {
        case .empty: NSLocalizedString("Email address is empty", comment: "")
        case .invalidEmailAddress: NSLocalizedString("Invalid email address", comment: "")
        }
    }
}
