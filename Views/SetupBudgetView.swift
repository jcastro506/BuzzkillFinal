import SwiftUI
import CoreLocation

struct SetBudgetView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var budgetModel: BudgetModel // Access the shared data model
    @StateObject private var locationManager = LocationManager()
    @State private var budgetAmount: String = "50"
    @State private var overBudgetAlert: Bool = false
    @State private var autoStartBudget: Bool = false
    @State private var showAutoStartPrompt: Bool = false
    @State private var showInfoAlert: Bool = false
    @State private var infoMessage: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SetBudgetHeaderView()

                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Set Your Budget")
                            .font(.title).bold()
                            .foregroundColor(.white)

                        VStack(spacing: 10) {
                            HStack {
                                Button("-") {
                                    if let amount = Double(budgetAmount), amount > 0 {
                                        budgetAmount = String(Int(amount - 5))
                                    }
                                }
                                .font(.title)
                                .padding()
                                .foregroundColor(.white)
                                
                                TextField("$", text: $budgetAmount)
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.white)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 80)
                                    .cornerRadius(8)
                                
                                Button("+") {
                                    if let amount = Double(budgetAmount) {
                                        budgetAmount = String(Int(amount + 5))
                                    }
                                }
                                .font(.title)
                                .padding()
                                .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                        }

                        HStack {
                            ForEach([30, 50, 100], id: \.self) { amount in
                                Button("$\(amount)") {
                                    budgetAmount = String(amount)
                                }
                                .padding()
                                .frame(width: 80)
                                .background(budgetAmount == String(amount) ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }

                        Text((Double(budgetAmount) ?? 0) < 50 ? "Low-key night" : (Double(budgetAmount) ?? 0) < 100 ? "Let's not get too crazy" : "Homelessness here we come")
                            .font(.subheadline)
                            .foregroundColor(.white)

                        Spacer().frame(height: 20)

                        HStack {
                            Toggle("Warn me when I get close", isOn: $overBudgetAlert)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                                .foregroundColor(.white)
                            
                            Button(action: {
                                infoMessage = "This toggle will alert you when you are close to exceeding your budget."
                                showInfoAlert = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                            }
                        }

                        HStack {
                            Toggle("Auto-Start When You Arrive at a Bar", isOn: $autoStartBudget)
                                .toggleStyle(SwitchToggleStyle(tint: .green))
                                .onChange(of: autoStartBudget) { newValue in
                                    if newValue {
                                        showAutoStartPrompt = true
                                        locationManager.requestPermission()
                                        locationManager.startUpdatingLocation()
                                    } else {
                                        locationManager.stopUpdatingLocation()
                                    }
                                }
                                .foregroundColor(.white)
                            
                            Button(action: {
                                infoMessage = "This toggle will automatically start your budget tracking when you arrive at a bar."
                                showInfoAlert = true
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                            }
                        }

                        Button(action: {
                            selectedTab = 2 // Switch to the Chat tab
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "message.fill")
                                Text("You're broke. Let's chat about cheap options.")
                                Spacer()
                            }
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 10)

                        Spacer()
                    }
                    .padding()
                }

                Button(action: {
                    if let amount = Double(budgetAmount) {
                        budgetModel.budgetAmount = amount // Update the shared data model
                        UserDefaults.standard.set(amount, forKey: "userBudget")
                        selectedTab = 0 // Switch to the Home tab
                    }
                }) {
                    Text("Lock it In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .alert(isPresented: $showInfoAlert) {
                Alert(title: Text("Information"), message: Text(infoMessage), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showAutoStartPrompt) {
                Alert(
                    title: Text("Enable Location Services"),
                    message: Text("To auto-start your budget when you arrive at a bar, please allow location services."),
                    primaryButton: .default(Text("Enable")) {
                        locationManager.requestPermission()
                    },
                    secondaryButton: .cancel(Text("Not Now")) {
                        autoStartBudget = false // Reset the toggle to off
                    }
                )
            }
        }
    }
}

struct SetBudgetHeaderView: View {
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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        default:
            stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
        if let location = locations.last {
            print("User's location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            // Add logic to determine if the user is at a bar
        }
    }
}

struct SetBudgetView_Previews: PreviewProvider {
    @State static var selectedTab = 0

    static var previews: some View {
        SetBudgetView(selectedTab: $selectedTab)
            .environmentObject(BudgetModel())
    }
}

