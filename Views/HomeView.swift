import SwiftUI

struct HomeView: View {
    @EnvironmentObject var budgetModel: BudgetModel // Access the shared data model
    @State private var spent: Double = 50.0
    @State private var transactions: [Transaction] = []
    @State private var selectedTransaction: Transaction?
    @State private var showEditSheet = false
    @State private var selectedPastBudget: PastBudget?
    @State private var showBudgetDetailModal = false

    var body: some View {
        VStack(spacing: 0) {
            HomeHeaderView()
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    BudgetProgressView(budget: budgetModel.budgetAmount, spent: spent) // Use the shared budget amount
                    PastBudgetsView(
                        selectedPastBudget: $selectedPastBudget,
                        showBudgetDetailModal: $showBudgetDetailModal
                    )
                    
                    CurrentTransactionsView(
                        transactions: $transactions,
                        selectedTransaction: $selectedTransaction,
                        showEditSheet: $showEditSheet
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color.black)
        .onAppear {
            // Update the budget when the view appears
            let newBudgetAmount = UserDefaults.standard.double(forKey: "userBudget")
            if budgetModel.budgetAmount != newBudgetAmount {
                budgetModel.budgetAmount = newBudgetAmount
            }
        }
        .sheet(isPresented: $showEditSheet) {
            if let transaction = selectedTransaction {
                EditTransactionView(transaction: transaction, transactions: $transactions)
            }
        }
        .sheet(isPresented: $showBudgetDetailModal) {
            if let budget = selectedPastBudget {
                BudgetDetailView(budget: budget)
            }
        }
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
    let budget: Double
    let spent: Double
    
    var progress: Double {
        return spent / budget
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0.0, to: min(progress, 1.0))
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 150, height: 150)
                    .animation(.easeOut(duration: 0.8), value: progress)
                
                if progress > 1.0 {
                    Circle()
                        .trim(from: 0.0, to: progress - 1.0)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)
                        .animation(.easeOut(duration: 0.8), value: progress)
                }
                
                VStack {
                    Text("$\(String(format: "%.2f", spent))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .animation(.easeInOut(duration: 0.3))
                    
                    Text("Remaining: $\(String(format: "%.2f", max(0, budget - spent)))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 20)
        }
    }
    
    private var progressColor: Color {
        if progress <= 0.4 {
            return Color.green
        } else if progress <= 0.7 {
            return Color.orange
        } else {
            return Color(red: 0.8, green: 0, blue: 0) // Darker red before overspending
        }
    }
}

extension Color {
    func interpolate(to color: Color, fraction: Double) -> Color {
        let clampedFraction = min(max(0, fraction), 1)
        let startComponents = self.components
        let endComponents = color.components
        
        let red = startComponents.red + (endComponents.red - startComponents.red) * clampedFraction
        let green = startComponents.green + (endComponents.green - startComponents.green) * clampedFraction
        let blue = startComponents.blue + (endComponents.blue - startComponents.blue) * clampedFraction
        
        return Color(red: red, green: green, blue: blue)
    }
    
    private var components: (red: Double, green: Double, blue: Double) {
        #if canImport(UIKit)
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (Double(red), Double(green), Double(blue))
        #else
        let nsColor = NSColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        nsColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (Double(red), Double(green), Double(blue))
        #endif
    }
}

// MARK: - Past Budgets View
struct PastBudgetsView: View {
    let pastBudgets: [PastBudget] = [
        PastBudget(
            barName: "Neon Lights Bar",
            date: "Feb 3, 2025",
            amountSpent: 80,
            budget: 100,
            transactions: [
                Transaction(id: UUID(), amount: 20, date: Date(), description: "Drinks", name: "Neon Lights Bar"),
                Transaction(id: UUID(), amount: 60, date: Date(), description: "Food", name: "Neon Lights Bar")
            ]
        ),
        PastBudget(
            barName: "The Golden Tap",
            date: "Jan 27, 2025",
            amountSpent: 120,
            budget: 100,
            transactions: [
                Transaction(id: UUID(), amount: 50, date: Date(), description: "Drinks", name: "The Golden Tap"),
                Transaction(id: UUID(), amount: 70, date: Date(), description: "Food", name: "The Golden Tap")
            ]
        ),
        PastBudget(
            barName: "Midnight Lounge",
            date: "Jan 20, 2025",
            amountSpent: 90,
            budget: 100,
            transactions: [
                Transaction(id: UUID(), amount: 30, date: Date(), description: "Drinks", name: "Midnight Lounge"),
                Transaction(id: UUID(), amount: 60, date: Date(), description: "Food", name: "Midnight Lounge")
            ]
        ),
        PastBudget(
            barName: "Electric Avenue",
            date: "Jan 15, 2025",
            amountSpent: 70,
            budget: 100,
            transactions: [
                Transaction(id: UUID(), amount: 40, date: Date(), description: "Drinks", name: "Electric Avenue"),
                Transaction(id: UUID(), amount: 30, date: Date(), description: "Food", name: "Electric Avenue")
            ]
        )
    ]
    @Binding var selectedPastBudget: PastBudget?
    @Binding var showBudgetDetailModal: Bool
    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text("Past Budgets")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 0)

            TabView(selection: $selectedIndex) {
                ForEach(pastBudgets.indices, id: \.self) { index in
                    BudgetCard(budget: pastBudgets[index])
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            selectedPastBudget = pastBudgets[index]
                            showBudgetDetailModal = true
                        }
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .frame(height: 160)
        }
    }
}

// MARK: - Transactions View
struct CurrentTransactionsView: View {
    @Binding var transactions: [Transaction]
    @Binding var selectedTransaction: Transaction?
    @Binding var showEditSheet: Bool
    
    @State private var showAllTransactions = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Recent Transactions")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            LazyVStack(spacing: 12) {
                ForEach(showAllTransactions ? transactions : Array(transactions.prefix(3)), id: \.id) { transaction in
                    TransactionRow(transaction: transaction) {
                        selectedTransaction = transaction
                        showEditSheet = true
                    }
                }
            }
            
            Button(action: {
                showAllTransactions.toggle()
            }) {
                Text(showAllTransactions ? "Show Less" : "View All")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding(.top, 10)
            .animation(.easeInOut(duration: 0.2), value: showAllTransactions)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    var onEdit: () -> Void
    
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
        .onTapGesture {
            onEdit()
        }
    }
}

struct EditTransactionView: View {
    var transaction: Transaction
    @Binding var transactions: [Transaction]

    @State private var newDescription: String
    @State private var newAmount: String

    @Environment(\.presentationMode) var presentationMode

    init(transaction: Transaction, transactions: Binding<[Transaction]>) {
        self.transaction = transaction
        self._transactions = transactions
        _newDescription = State(initialValue: transaction.description)
        _newAmount = State(initialValue: String(format: "%.2f", transaction.amount))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Edit Transaction")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    Text("Description")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Enter description", text: $newDescription)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)

                    Text("Amount")
                        .font(.headline)
                        .foregroundColor(.gray)
                    TextField("Enter amount", text: $newAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)

                HStack(spacing: 20) {
                    Button(action: saveChanges) {
                        Text("Save")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                    Button(action: deleteTransaction) {
                        Text("Delete")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveChanges() {
        if let amount = Double(newAmount) {
            if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
                transactions[index] = Transaction(
                    id: transaction.id,
                    amount: amount,
                    date: transaction.date,
                    description: newDescription,
                    name: transaction.name
                )
            }
        }
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteTransaction() {
        transactions.removeAll { $0.id == transaction.id }
        presentationMode.wrappedValue.dismiss()
    }
}

struct BudgetCard: View {
    let budget: PastBudget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(budget.barName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(budget.date)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
                
                Text(budget.isUnderBudget ? "✔️" : "⚠️")
                    .font(.title2)
                    .foregroundColor(budget.isUnderBudget ? .green : .red)
            }
            
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle(tint: budget.isUnderBudget ? Color.green : Color.red))
                .frame(height: 8)
                .cornerRadius(4)
                .padding(.vertical, 4)
            
            HStack {
                Text("Spent: $\(String(format: "%.2f", budget.amountSpent))")
                    .font(.footnote)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Budget: $\(String(format: "%.2f", budget.budget))")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .frame(width: 260, height: 140)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.systemGray5).opacity(0.2))
                .shadow(radius: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
    
    private var progressValue: Double {
        guard budget.budget > 0 else { return 0 }
        return min(max(budget.amountSpent / budget.budget, 0), 1)
    }
}

struct BudgetCarouselView: View {
    let budgets: [PastBudget]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(budgets) { budget in
                    BudgetCard(budget: budget)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// New view for budget details
struct BudgetDetailView: View {
    let budget: PastBudget

    var body: some View {
        VStack(spacing: 20) {
            Text(budget.barName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("Date: \(budget.date)")
                .font(.headline)
                .foregroundColor(.gray)

            Text("Amount Spent: $\(String(format: "%.2f", budget.amountSpent))")
                .font(.title)
                .foregroundColor(.white)

            Text("Budget: $\(String(format: "%.2f", budget.budget))")
                .font(.title)
                .foregroundColor(.white)

            if budget.isUnderBudget {
                Text("You underspent by $\(String(format: "%.2f", budget.underspentAmount))")
                    .font(.headline)
                    .foregroundColor(.green)
            } else {
                Text("You overspent by $\(String(format: "%.2f", budget.overspentAmount))")
                    .font(.headline)
                    .foregroundColor(.red)
            }

            List(budget.transactions) { transaction in
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
            }
            .listStyle(PlainListStyle())
            .frame(maxHeight: 300) // Adjust height as needed

            Spacer()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a sample BudgetModel with mock data
        let sampleBudgetModel = BudgetModel()
        sampleBudgetModel.budgetAmount = 200.0 // Set a sample budget amount

        return HomeView()
            .environmentObject(sampleBudgetModel) // Provide the sample model to the environment
            .preferredColorScheme(.dark)
    }
}
