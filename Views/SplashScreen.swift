import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack {
            Image(systemName: "sparkles")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
                .padding()
            Text("Buzzkill")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            // Simulate loading data from the backend
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Transition to the next view, e.g., OnboardingView
            }
        }
    }
}

#Preview {
    SplashScreen()
} 