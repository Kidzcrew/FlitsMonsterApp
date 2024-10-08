//
//  AppSettings.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 03/10/2024.
//

import Foundation

struct AppSettings {
    // Keys for UserDefaults
    private static let standaardGroepKey = "GeselecteerdeGroep"
    private static let taalKey = "userLanguage"
    
    // Standaardwaarden
    static let standaardGroep = "Alle lijsten"
    static let standaardTaal: AppLanguage = .nl // Default language is Dutch

    // Retrieve and set the selected group
    static func getGeselecteerdeGroep() -> String {
        return UserDefaults.standard.string(forKey: standaardGroepKey) ?? standaardGroep
    }

    static func setGeselecteerdeGroep(_ groep: String) {
        UserDefaults.standard.set(groep, forKey: standaardGroepKey)
    }

    // Retrieve and set the selected language
    static func getTaal() -> AppLanguage {
        let storedLanguage = UserDefaults.standard.string(forKey: taalKey)
        return AppLanguage(rawValue: storedLanguage ?? standaardTaal.rawValue) ?? standaardTaal
    }

    static func setTaal(_ taal: AppLanguage) {
        UserDefaults.standard.set(taal.rawValue, forKey: taalKey)
    }

    // Reset function to clear saved preferences
    static func resetDefaults() {
        UserDefaults.standard.removeObject(forKey: standaardGroepKey)
        UserDefaults.standard.removeObject(forKey: taalKey)
        // Verwijder hier ook andere opgeslagen instellingen indien nodig
    }
}

// Enum to manage the language options
enum AppLanguage: String {
    case nl = "nl"  // Dutch
    case en = "en"  // English
}
