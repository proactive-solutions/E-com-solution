//
//  NameViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 21/07/2025.
//

import Combine
import DataModels
import Foundation
import ValidationKit

final class NameViewModel: ObservableObject {
    @Published var userName = ""
    @Published var nameValidationError: String?

    private(set) var name: Result<Name, Validator.NameValidationError>?
    private var cancellables = Set<AnyCancellable>()

    private let dropFirst: Int
    private let debounceTime: DispatchQueue.SchedulerTimeType.Stride

    init(
        debounceTime: DispatchQueue.SchedulerTimeType.Stride = 0.3,
        dropFirst: Int = 1
    ) {
        self.debounceTime = debounceTime
        self.dropFirst = dropFirst
        validateNameInput()
    }

    private func validateNameInput() {
        let userNameSub = $userName
            .debounce(for: debounceTime, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst(dropFirst)
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
}
