import ComposableArchitecture
import SwiftUI
import UIComponents

struct ForgotPasswordView: View {
  private let forgotPasswordStore = Store(
    initialState: ForgotPasswordFeature.State()
  ) { ForgotPasswordFeature() }

  let onDismiss: () -> Void

  var body: some View {
    WithViewStore(forgotPasswordStore, observe: { $0 }) { viewStore in
      NavigationView {
        VStack(spacing: 20) {
          // Forgot Password Section
          Image(systemName: "key.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
            .background(Color.blue.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
          
          HeadingText("Forgot Password?")
          SubHeadingText("Don't worry! It happens. Please enter the email address associated with your account.")
          
          // How it works Section
          VStack(alignment: .leading, spacing: 10) {
            Text("How it works")
              .font(.headline)
              .foregroundColor(.blue)
            
            HStack {
              Text("1")
                .foregroundColor(.blue)
              Text("Enter your email address below")
            }
            HStack {
              Text("2")
                .foregroundColor(.blue)
              Text("Check your email for a reset link")
            }
            HStack {
              Text("3")
                .foregroundColor(.blue)
              Text("Click the link to create a new password")
            }
          }
          .padding()
          .background(Color.blue.opacity(0.1))
          .cornerRadius(10)
          
          // Email Input
          VStack(alignment: .leading) {
            Text("Email Address")
              .font(.headline)
            TextField(
              "Enter your email address",
              text: viewStore.binding(
                get: \.forgotPasswordEmail,
                send: { .forgotPasswordEmailChanged($0) }
              )
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .keyboardType(.emailAddress)

            if let validationError = viewStore.emailValidationError {
              ErrorMessageView(message: validationError)
            }
          }
          
          // Send Reset Link Button
          PrimaryButton(
            title: "Send Reset Link",
            isLoading: viewStore.forgotPasswordLoading,
            isEnabled: viewStore.isForgotPasswordEmailValid,
            action: { viewStore.send(.sendPasswordReset) }
          )
          
          // Didn't receive email link
          Button("Didn't receive the email? Check your spam folder or resend link") {
            viewStore.send(.sendPasswordReset)
          }
          .foregroundColor(.gray)
          .multilineTextAlignment(.center)
          .padding(.top, 10)
          .disabled(viewStore.forgotPasswordLoading)

          Spacer()
        }
        .padding()
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") { onDismiss() }
          }
        }
        .alert(isPresented: .constant(viewStore.forgotPasswordMessage != nil)) {
          Alert(
            title: Text(viewStore.forgotPasswordSuccess ? "Success" : "Error"),
            message: Text(viewStore.forgotPasswordMessage ?? ""),
            dismissButton: .default(Text("OK")) {
              if viewStore.forgotPasswordSuccess { onDismiss() }
            }
          )
        }
      }
    }
  }
}

//#Preview {
//  ForgotPasswordView(
//    email: .constant(""),
//    isLoading: false,
//    isEmailValid: true,
//    message: nil,
//    isSuccess: false,
//    onSendReset: {},
//    onDismiss: {}
//  )
//}
