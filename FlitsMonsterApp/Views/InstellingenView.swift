// InstellingenView.swift

import SwiftUI

struct InstellingenView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("selectedLanguage") private var selectedLanguage = "Nederlands"
    @AppStorage("flitstijd") private var flitstijd: Double = 60
    @AppStorage("onzichtbaarNa") private var onzichtbaarNa: Double = 1.5
    @AppStorage("showProgressBar") private var showProgressBar = true
    @AppStorage("enableKlankView") private var enableKlankView = true // Nieuw: optie voor KlankView
    @AppStorage("selectedFont") private var selectedFont = "San Francisco"

    let languages = ["Engels", "Nederlands"]
    let fonts = ["San Francisco", "Dyslexie", "Krijtbord", "School"]

    var body: some View {
        NavigationStack {
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

                Section(header: Text("Flitstijd")) {
                    Slider(value: $flitstijd, in: 15...120, step: 15) {
                        Text("Flitstijd")
                    } minimumValueLabel: {
                        Text("15 sec")
                    } maximumValueLabel: {
                        Text("2 min")
                    }
                    Text("Flitstijd: \(formattedFlitstijd())")
                }

                Section(header: Text("Lettertype")) {
                    Picker("Selecteer Lettertype", selection: $selectedFont) {
                        ForEach(fonts, id: \.self) { font in
                            Text(font).tag(font)
                        }
                    }
                }

                Section(header: Text("Onzichtbaar na")) {
                    Slider(value: $onzichtbaarNa, in: 0.5...3, step: 0.5) {
                        Text("Onzichtbaar na")
                    } minimumValueLabel: {
                        Text("0,5 sec")
                    } maximumValueLabel: {
                        Text("3 sec")
                    }
                    Text("Onzichtbaar na: \(formattedOnzichtbaarNa())")
                }

                Section(header: Text("Progress Bar")) {
                    Toggle("Show Progress Bar", isOn: $showProgressBar)
                }
                
                // Nieuwe toggle voor KlankView
                Section(header: Text("Klankweergave")) {
                    Toggle("Toon klanken in afzonderlijke hokjes", isOn: $enableKlankView)
                }
            }
            .navigationTitle("Instellingen")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }

    private func formattedFlitstijd() -> String {
        switch flitstijd {
        case 15:
            return "15 seconden"
        case 30:
            return "30 seconden"
        case 45:
            return "45 seconden"
        case 60:
            return "1 minuut"
        case 75:
            return "1 minuut en 15 seconden"
        case 90:
            return "1 minuut en 30 seconden"
        case 105:
            return "1 minuut en 45 seconden"
        case 120:
            return "2 minuten"
        default:
            return "\(Int(flitstijd)) seconden"
        }
    }

    private func formattedOnzichtbaarNa() -> String {
        switch onzichtbaarNa {
        case 0.5:
            return "0,5 seconde"
        case 1:
            return "1 seconde"
        case 1.5:
            return "1,5 seconde"
        case 2:
            return "2 seconden"
        case 2.5:
            return "2,5 seconden"
        case 3:
            return "3 seconden"
        default:
            return "\(onzichtbaarNa) seconden"
        }
    }
}

#Preview {
    InstellingenView()
}
