import SwiftUI

struct InstellingenView: View {
    // State for theme (light/dark mode)
    @AppStorage("isDarkMode") private var isDarkMode = false
    // State for selected language
    @AppStorage("selectedLanguage") private var selectedLanguage = "Nederlands"

    let languages = ["Engels", "Nederlands"]

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                }
            }

            Section(header: Text("Language")) {
                Picker("Select Language", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { language in
                        Text(language).tag(language)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .navigationTitle("Settings")
        .preferredColorScheme(isDarkMode ? .dark : .light) // Apply dark/light mode
        .onAppear {
            print("Selected Language on Appear: \(selectedLanguage)")
        }
        .onChange(of: selectedLanguage) {
            print("Selected Language changed to: \(selectedLanguage)")
        }
    }
}

#Preview {
    InstellingenView()
}
