import SwiftUI


// MARK: - Home View
struct HomeView: View {
    @State private var transactions: [Transaction] = [
        Transaction(id: UUID(), amount: 14.99, date: Date(), description: "Whiskey Sour", name: "Bar Tab"),
        Transaction(id: UUID(), amount: 24.50, date: Date(), description: "Beer Pitcher", name: "Brew Pub"),
        Transaction(id: UUID(), amount: 12.00, date: Date(), description: "Margarita", name: "Mexican Grill"),
        Transaction(id: UUID(), amount: 18.99, date: Date(), description: "Appetizer Platter", name: "Sports Bar")
    ]

    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView() // Sticky header

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) { // Reduce spacing from 20 to 16
                    BudgetProgressView()
                    PastBudgetsView()
                    
                    // Fix padding issue
                    CurrentTransactionsView(transactions: $transactions)
                        .padding(.top, 8) // Reduce gap above transactions
                }
                .padding(.bottom, 50) // Add padding to avoid content being hidden by the tab bar
            }
        }
        .background(Color.black)
    }
}



// MARK: - Home Header View
struct HomeHeaderView: View {
    var body: some View {
        HStack {
            Text("Buzzkill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)

            Spacer()

            HStack(spacing: 16) {
                Button(action: { }) {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }

                Button(action: { }) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }
            }
            .padding(.trailing, 16)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
}

// MARK: - Budget Progress View
struct BudgetProgressView: View {
    @State private var budget: Double? = 100.0
    @State private var spent: Double = 40.0

    var progress: Double {
        guard let budget = budget else { return 0.0 }
        return max(0, (budget - spent) / budget)
    }

    var progressColor: LinearGradient {
        let colors: [Color]
        switch progress {
        case 0.7...1.0:
            colors = [Color.green, Color.green.opacity(0.8)]
        case 0.3..<0.7:
            colors = [Color.yellow, Color.orange]
        default:
            colors = [Color.red, Color.red.opacity(0.7)]
        }

        return LinearGradient(gradient: Gradient(colors: colors),
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }

    var body: some View {
        VStack {
            if let budget = budget {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                        .frame(width: 150, height: 150)

                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(progressColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)
                        .animation(.easeOut(duration: 0.8), value: progress)

                    VStack {
                        Text("$\(Int(budget - spent))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("left in budget")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)
            }
        }
    }
}

// MARK: - Past Budgets View
struct PastBudgetsView: View {
    let pastBudgets: [PastBudget] = [
        PastBudget(barName: "Neon Lights Bar", date: "Feb 3, 2025", amountSpent: 80, budget: 100),
        PastBudget(barName: "The Golden Tap", date: "Jan 27, 2025", amountSpent: 120, budget: 100),
        PastBudget(barName: "Midnight Lounge", date: "Jan 20, 2025", amountSpent: 90, budget: 100),
        PastBudget(barName: "Electric Avenue", date: "Jan 15, 2025", amountSpent: 70, budget: 100)
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Past Budgets")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.leading, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(pastBudgets) { budget in
                        BudgetCard(budget: budget)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Current Transactions View (Properly Adjusted Spacing)
struct CurrentTransactionsView: View {
    @Binding var transactions: [Transaction]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Current Transactions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.leading, 16)

            if transactions.isEmpty {
                Text("No transactions yet")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(transactions) { transaction in
                        TransactionRow(transaction: transaction) {
                            withAnimation {
                                transactions.removeAll { $0.id == transaction.id }
                            }
                        }
                        .listRowBackground(Color.black)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.black)
                .frame(height: 300)
            }
        }
        .background(Color.black)
    }
}

// MARK: - Transaction Row (Same as Before)
struct TransactionRow: View {
    let transaction: Transaction
    var onDelete: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.description)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(transaction.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("-$\(String(format: "%.2f", transaction.amount))")
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .swipeActions {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                print("Edit \(transaction.description)")
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }
}

// MARK: - Budget Card
struct BudgetCard: View {
    let budget: PastBudget

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(budget.barName)
                .font(.headline)
                .foregroundColor(.white)

            Text(budget.date)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            Text(budget.isUnderBudget ? "Under Budget" : "Over Budget")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
                .background(budget.isUnderBudget ? Color.green.opacity(0.6) : Color.red.opacity(0.7))
                .cornerRadius(8)

            HStack {
                Text("Spent: $\(Int(budget.amountSpent))")
                    .font(.caption)
                    .foregroundColor(.white)

                Spacer()

                Text("Budget: $\(Int(budget.budget))")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .frame(width: 250)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color.gray]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}
