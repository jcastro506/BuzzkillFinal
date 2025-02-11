import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Logo
            Image(systemName: "This is a test") // Replace with your logo or image
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
            Text("Log In to Buzzkill")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            // Input fields
            Group {
                CustomTextField(icon: "envelope.fill", placeholder: "Email", text: .constant(""))
                CustomTextField(icon: "lock.fill", placeholder: "Password", text: .constant(""), isSecure: true)
            }
            .padding(.horizontal, 20)
            
            // Log In Button
            // Button(action: {
            //     // Log in action
            // }) {
            //     Text("Log In")
            //         .font(.system(size: 18, weight: .bold, design: .rounded))
            //         .foregroundColor(.white)
            //         .frame(maxWidth: .infinity)
            //         .padding()
            //         .background(
            //             LinearGradient(
            //                 gradient: Gradient(colors: [Color.cyan, Color.blue]),
            //                 startPoint: .leading,
            //                 endPoint: .trailing
            //             )
            //             .cornerRadius(12)
            //             .shadow(color: Color.blue.opacity(0.5), radius: 10, x: 0, y: 5)
            //         )
            // }
            // .padding(.horizontal, 20)
            // .padding(.top, 10)

            NavigationLink(destination: HomeView()) {
                    Text("Log In")
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
} 