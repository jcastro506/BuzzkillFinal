import SwiftUI

struct OnboardingView: View {
    @State private var currentQuestionIndex = 0
    @State private var progress: CGFloat = 0.0
    @State private var isComplete = false
    @State private var selectedAnswers: [Int?]

    let questions = [
        "How much money did you lose to ‘just one more round’ last month?",
        "Be honest: Have you ever checked your bank account the morning after and thought… ‘who TF stole my money?’",
        "Your last big night out cost as much as...",
        "How often do you end up buying drinks for ‘friends’ you just met?",
        "Your liver has a savings account. What’s your balance?",
        "If your bar tab had an investment portfolio, how rich would you be?"
    ]

    let answers = [
        ["$0 - I am a responsible adult (Lies.)", "$20 - $50 (I mean, that’s just a couple of Ubers home…)", "$50 - $100 (That’s like...a full year of Netflix.)", "More than $100 (You could’ve bought stocks, but no. You bought tequila.)"],
        ["No, I always budget my fun (Sure, buddy.)", "Once or twice, but I like living on the edge.", "Every weekend. My bank statements give me anxiety.", "I don’t even check. If I don’t see it, it didn’t happen."],
        ["A week’s worth of groceries. Hope you enjoy ramen.", "A whole year of Amazon Prime. But hey, at least you got bottle service.", "A car payment. Because alcohol is definitely an asset.", "A round-trip flight to another country. But you went to the same bar... again."],
        ["Never. I only pay for myself (and my future financial stability).", "Rarely, but only when I’m already tipsy.", "Often. It’s called being a good time.", "Every weekend. I basically fund the bar’s rent."],
        ["$500 - $1,000: Healthy-ish.", "$50 - $500: A little rough, but still standing.", "$0 - I drink like I’m on vacation.", "Overdrawn. My liver just sent me a Venmo request."],
        ["A decent savings account. I make smart choices.", "A struggling startup. Some wins, mostly losses.", "I could’ve been a crypto millionaire. Instead, I bought Fireball shots.", "I own negative assets. Even my past self regrets me."]
    ]

    init() {
        _selectedAnswers = State(initialValue: Array(repeating: nil, count: questions.count))
    }

    var body: some View {
        NavigationView {
            VStack {
                // Progress Bar
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                Spacer()

                // Question
                Text(questions[currentQuestionIndex])
                    .font(.title)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()

                // Answer Options with Selection Highlight
                ForEach(answers[currentQuestionIndex].indices, id: \.self) { index in
                    Button(action: {
                        selectedAnswers[currentQuestionIndex] = index
                    }) {
                        Text(answers[currentQuestionIndex][index])
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedAnswers[currentQuestionIndex] == index
                                    ? Color.cyan.opacity(0.8)
                                    : Color.blue.opacity(0.7)
                            )
                            .cornerRadius(12)
                            .animation(.easeInOut, value: selectedAnswers[currentQuestionIndex])
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()

                // Navigation Buttons
                HStack {
                    Button(action: {
                        currentQuestionIndex -= 1
                        progress = CGFloat(currentQuestionIndex) / CGFloat(questions.count - 1)
                    }) {
                        Text("Previous")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .opacity(currentQuestionIndex == 0 ? 0 : 1) // Hide but keep space

                    Spacer() // Ensures even spacing

                    NavigationLink(destination: HomeView(), isActive: $isComplete) {
                        EmptyView()
                    }

                    Button(action: {
                        if currentQuestionIndex < questions.count - 1 {
                            currentQuestionIndex += 1
                            progress = CGFloat(currentQuestionIndex) / CGFloat(questions.count - 1)
                        } else {
                            isComplete = true
                        }
                    }) {
                        Text(currentQuestionIndex < questions.count - 1 ? "Next" : "Finish")
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
                            .opacity(selectedAnswers[currentQuestionIndex] == nil ? 0.5 : 1.0) // Visually disable button
                    }
                    .padding(.horizontal, 20)
                    .disabled(selectedAnswers[currentQuestionIndex] == nil) // Disable if no answer is selected
                }
                .frame(maxWidth: .infinity) // Ensures both buttons are aligned properly

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
            .onAppear {
                progress = 0.0
                currentQuestionIndex = 0
                isComplete = false
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
