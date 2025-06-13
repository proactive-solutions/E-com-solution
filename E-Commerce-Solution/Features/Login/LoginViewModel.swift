//
//  LoginViewModel.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import Models
import Foundation

struct LoginViewModel {
  private(set) var email: EmailAddress?
  private(set) var name: Name?
  private(set) var mobileNumber: MobileNumber?

  mutating func set(email: String) {
    do {
      let _email = try EmailAddress(email)
      self.email = _email
    } catch let result {
      // TODO: Handle the error here for email validation failure
      self.email = nil
    }
  }

  mutating func set(name: String) {
    do {
      let _name = try Name(name)
      self.name = _name
    } catch let result {
      // TODO: Handle the error here for Name validation failure
      self.name = nil
    }
  }

  mutating func set(mobileNumber: String) {
    do {
      let _mobileNumber = try MobileNumber(mobileNumber)
      self.mobileNumber = _mobileNumber
    } catch let result {
      // TODO: Handle the error here for mobile number validation failure
      self.mobileNumber = nil
    }
  }
}
