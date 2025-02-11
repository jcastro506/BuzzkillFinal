import SwiftUI

struct SignUpView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // Logo
                Image(systemName: "This is a test")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(20)
                    .background(
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                    )
                    .padding(.bottom, 20)
                
                // Title
                Text("Welcome to Buzzkill")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your wallets only friend at the bar.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 30)
                
                // Input fields
                Group {
                    CustomTextField(icon: "person.fill", placeholder: "Username", text: .constant(""))
                    CustomTextField(icon: "envelope.fill", placeholder: "Email", text: .constant(""))
                    CustomTextField(icon: "lock.fill", placeholder: "Password", text: .constant(""), isSecure: true)
                    CustomTextField(icon: "lock.fill", placeholder: "Confirm Password", text: .constant(""), isSecure: true)
                }
                .padding(.horizontal, 20)
                
                // Sign Up Button
                NavigationLink(destination: OnboardingView()) {
                    Text("Sign Up Free")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                // Login Option
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.white.opacity(0.8))
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .fontWeight(.bold)
                            .foregroundColor(Color.cyan)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.gray]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}

// MARK: - Custom Text Field
import SwiftUI

struct CustomTextField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 10)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6)) // Placeholder in white
                        .padding(.vertical, 12)
                        .padding(.leading, 5)
                }
                
                if isSecure {
                    SecureField("", text: $text)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.leading, 5)
                } else {
                    TextField("", text: $text)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.leading, 5)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
                .shadow(color: Color.white.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
