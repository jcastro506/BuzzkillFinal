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
                    MainTabView() // Use MainTabView if user is signed in
                        .preferredColorScheme(.dark) // Enforce dark mode
                } else {
                    SignUpView() // Direct to SignUpView if user is not signed in
                        .preferredColorScheme(.dark) // Enforce dark mode
                }
            }
        }
    }
}
