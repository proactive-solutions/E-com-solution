import FirebaseAuth
import FirebaseCore
import SwiftUI

// MARK: - App Delegate

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
    FirebaseApp.configure()
    return true
  }
}
