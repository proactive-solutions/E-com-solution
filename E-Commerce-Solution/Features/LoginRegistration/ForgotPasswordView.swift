import SwiftUI

struct ForgotPasswordView: View {
    // MARK: - Properties
    @State private var email: String = ""

    // MARK: - Body
    var body: some View {
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
                TextField("Enter your email address", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }

            // Send Reset Link Button
            Button(action: {
                // Handle send reset link action
            }) {
                Text("Send Reset Link")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            // Didn't receive email link
            Text("Didn't receive the email? Check your spam folder or resend link")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    ForgotPasswordView()
}
