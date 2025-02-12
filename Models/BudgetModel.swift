import SwiftUI
import Combine

class BudgetModel: ObservableObject {
    @Published var budgetAmount: Double = 0.0
} 