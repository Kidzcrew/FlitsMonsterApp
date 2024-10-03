//
//  AppSettings.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 03/10/2024.
//


import Foundation

struct AppSettings {
    private static let standaardGroepKey = "GeselecteerdeGroep"
    
    // Voeg hier standaardwaarden toe
    static let standaardGroep = "Alle lijsten"
    
    static func getGeselecteerdeGroep() -> String {
        return UserDefaults.standard.string(forKey: standaardGroepKey) ?? standaardGroep
    }

    static func setGeselecteerdeGroep(_ groep: String) {
        UserDefaults.standard.set(groep, forKey: standaardGroepKey)
    }

    // Voeg hier meer instellingen toe
    static func resetDefaults() {
        UserDefaults.standard.removeObject(forKey: standaardGroepKey)
        // Verwijder hier ook andere opgeslagen instellingen indien nodig
    }
}