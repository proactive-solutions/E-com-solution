//
//  E_Commerce_SolutionApp.swift
//  E-Commerce-Solution
//
//  Created by Pawan Sharma on 12/06/2025.
//

import SwiftUI

@main
struct E_Commerce_SolutionApp: App {
  let persistenceController = PersistenceController.shared
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      LoginRegistrationView()
    }
  }
}
