import Foundation

struct PastBudget: Identifiable {
    let id = UUID()
    let barName: String
    let date: String
    let amountSpent: Double
    let budget: Double

    var isUnderBudget: Bool {
        amountSpent <= budget
    }
} 