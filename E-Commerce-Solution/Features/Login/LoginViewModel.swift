//
//  LoginViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Models
import ValidationKit
import Foundation

struct LoginViewModel {
  private(set) var email: EmailAddress?
  private(set) var name: Name?
  private(set) var mobileNumber: MobileNumber?

  mutating func set(email: String) {
    do {
      let _email = try EmailAddress(email)
      self.email = _email
    } catch let error as Validator.EmailValidationResult {
      // TODO: Handle the error here for email validation failure
      print(error.localizedDescription)
      self.email = nil
    } catch let error {
      print("Unknown Error: ", error.localizedDescription)
    }
  }

  mutating func set(name: String) {
    do {
      let _name = try Name(name)
      self.name = _name
    } catch let error as Validator.NameValidationResult {
      // TODO: Handle the error here for Name validation failure
      print(error.localizedDescription)
    } catch let error {
      print("Unknown Error: ", error.localizedDescription)
    }
  }

  mutating func set(mobileNumber: String) {
    do {
      let _mobileNumber = try MobileNumber(mobileNumber)
      self.mobileNumber = _mobileNumber
    } catch let error as Validator.MobileNumberValidationResult {
      self.mobileNumber = nil
      print(error.localizedDescription)
    } catch let error {
      // TODO: Handle the error here for mobile number validation failure
      print("Unknown Error: ", error.localizedDescription)
    }
  }
}
