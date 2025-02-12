//
//  BuzzkillApp.swift
//  Buzzkill
//
//  Created by Josh Castro on 2/10/25.
//

import SwiftUI

@main
struct BuzzkillApp: App {
    @State private var isSplashScreenActive = true
    @State private var isUserSignedIn = true // Set to true for testing
    @State private var selectedTab = 0
    @StateObject private var budgetModel = BudgetModel() // Create the shared data model

    var body: some Scene {
        WindowGroup {
            if isSplashScreenActive {
                SplashScreen()
                    .onAppear {
                        // Simulate loading data from the backend
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isSplashScreenActive = false
                        }
                    }
                    .preferredColorScheme(.dark) // Enforce dark mode
            } else {
                if isUserSignedIn {
                    MainTabView(selectedTab: $selectedTab)
                        .environmentObject(budgetModel) // Provide the shared data model
                        .preferredColorScheme(.dark) // Enforce dark mode
                } else {
                    SignUpView()
                        .preferredColorScheme(.dark) // Enforce dark mode
                }
            }
        }
    }
}
