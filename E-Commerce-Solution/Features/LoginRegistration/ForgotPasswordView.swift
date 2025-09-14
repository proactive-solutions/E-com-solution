import ComposableArchitecture
import SwiftUI
import UIComponents

struct ForgotPasswordView: View {
  private let forgotPasswordStore = Store(
    initialState: ForgotPasswordFeature.State()
  ) { ForgotPasswordFeature() }

  private let emailStore = Store(
    initialState: EmailValidationFeature.State()
  ) { EmailValidationFeature() }

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
          
          EmailValidationView(store: emailStore)
          
          // Send Reset Link Button
          PrimaryButton(
            title: "Send Reset Link",
            isLoading: viewStore.forgotPasswordLoading,
            action: {
              guard let email = try? emailStore.validatedEmailResult?.get() else { return }
              viewStore.send(.sendPasswordReset(email.value))
            }
          )
          .disabled(viewStore.forgotPasswordLoading)

          // Didn't receive email link
          Button("Didn't receive the email? Check your spam folder or resend link") {
            guard let email = try? emailStore.validatedEmailResult?.get() else { return }
            viewStore.send(.sendPasswordReset(email.value))
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

#Preview {
  ForgotPasswordView(onDismiss: {

  })
}
