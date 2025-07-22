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
    private(set) var emailResult: Result<EmailAddress, Validator.EmailValidationError>?

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
        $userEmail
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
                self.emailResult = result
                if case let .failure(reason) = self.emailResult {
                    emailValidationError = self.emailErrorDescription(result: reason)
                } else {
                    emailValidationError = nil
                }
            }
            .store(in: &cancellables)
    }

    func emailErrorDescription(result: Validator.EmailValidationError) -> String {
        switch result {
        case .empty              : "Email address is empty".localize()
        case .invalidEmailAddress: "Invalid email address".localize()
        }
    }
}
