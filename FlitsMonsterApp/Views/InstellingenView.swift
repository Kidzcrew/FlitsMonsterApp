import SwiftUI

struct InstellingenView: View {
    // State for theme (light/dark mode)
    @AppStorage("isDarkMode") private var isDarkMode = false
    // State for selected language
    @AppStorage("selectedLanguage") private var selectedLanguage = "Nederlands"
    // State for flitstijd (flashcard time) with default 60 seconds (1 minute)
    @AppStorage("flitstijd") private var flitstijd: Double = 60

    let languages = ["Engels", "Nederlands"]
    let flitstijdOpties: [Double] = [15, 30, 45, 60, 75, 90, 105, 120]  // Flitstijd opties in seconden

    var body: some View {
        Form {
            // Section for Dark Mode
            Section(header: Text("Appearance")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
                .onChange(of: isDarkMode, initial: false) { oldValue, newValue in
                    print("Dark Mode changed from: \(oldValue ? "Enabled" : "Disabled") to: \(newValue ? "Enabled" : "Disabled")")
                }
            }

            // Section for language selection
            Section(header: Text("Language")) {
                Picker("Select Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: selectedLanguage, initial: false) { oldLanguage, newLanguage in
                    print("Selected Language changed from: \(oldLanguage) to: \(newLanguage)")
                }
            }

            // Section for Flitstijd (flashcard time) slider
            Section(header: Text("Flitstijd Instellen")) {
                VStack(alignment: .leading) {
                    // Display the currently selected flitstijd value in minutes/seconds format
                    Text("Flitstijd: \(formatFlitstijd(flitstijd))")
                    
                    // Slider for flitstijd, with steps of the predefined options
                    Slider(
                        value: $flitstijd,
                        in: flitstijdOpties.first!...flitstijdOpties.last!,
                        step: 15
                    )
                    .onChange(of: flitstijd, initial: false) { oldValue, newValue in
                        print("Flitstijd changed from: \(formatFlitstijd(oldValue)) to: \(formatFlitstijd(newValue))")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply dark/light mode
        .onAppear {
            print("Selected Language on Appear: \(selectedLanguage)")
            print("Flitstijd on Appear: \(formatFlitstijd(flitstijd))")
        }
    }

    // Helper function to format flitstijd as human-readable format
    private func formatFlitstijd(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        
        switch (minutes, seconds) {
        case (0, 15):
            return "15 seconden"
        case (0, 30):
            return "30 seconden"
        case (0, 45):
            return "45 seconden"
        case (1, 0):
            return "1 minuut"
        case (1, 15):
            return "1 minuut en 15 seconden"
        case (1, 30):
            return "1 minuut en 30 seconden"
        case (1, 45):
            return "1 minuut en 45 seconden"
        case (2, 0):
            return "2 minuten"
        default:
            return "\(minutes)m \(seconds)s"
        }
    }
}

#Preview {
    InstellingenView()
}
