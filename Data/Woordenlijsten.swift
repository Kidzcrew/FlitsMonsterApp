//
//  Woordenlijsten.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

extension Lijst {
    static let lijstM3 = Lijst(naam: "lijst groep 3 Start", beschrijving: "Lijst voor groep 3", niveau: .M3)
    static let lijstM4 = Lijst(naam: "lijst groep 4", beschrijving: "Lijst voor groep 4", niveau: .M4)
    static let lijstM5 = Lijst(naam: "lijst groep 5", beschrijving: "Lijst voor groep 5", niveau: .M5)
    static let lijstM6 = Lijst(naam: "lijst groep 6", beschrijving: "Lijst voor groep 6", niveau: .M6)
    static let lijstM7 = Lijst(naam: "lijst groep 7", beschrijving: "Lijst voor groep 7", niveau: .M7)
    static let lijst8plus = Lijst(naam: "lijst groep 8", beschrijving: "Lijst voor groep 8", niveau: .eightPlus)
    static let lijstE3 = Lijst(naam: "lijst groep 3 Eind", beschrijving: "Eindlijst voor groep 3", niveau: .E3)
    static let lijstE4 = Lijst(naam: "lijst groep 4 Eind", beschrijving: "Eindlijst voor groep 4", niveau: .E4)
    static let lijstE5 = Lijst(naam: "lijst groep 5 Eind", beschrijving: "Eindlijst voor groep 5", niveau: .E5)
    static let lijstE6 = Lijst(naam: "lijst groep 6 Eind", beschrijving: "Eindlijst voor groep 6", niveau: .E6)
    static let lijstE7 = Lijst(naam: "lijst groep 7 Eind", beschrijving: "Eindlijst voor groep 7", niveau: .E7)
    static let eigenlijst = Lijst(naam: "eigen lijst", beschrijving: "niveau niet bepaald", niveau: .eigen)

    static func insertSampleData(modelContext: ModelContext) {
        // Voeg de Lijst categorieën toe aan de modelcontext.
        modelContext.insert(lijstM3)
        modelContext.insert(lijstM4)
        modelContext.insert(lijstM5)
        modelContext.insert(lijstM6)
        modelContext.insert(lijstM7)
        modelContext.insert(lijst8plus)
        modelContext.insert(lijstE3)
        modelContext.insert(lijstE4)
        modelContext.insert(lijstE5)
        modelContext.insert(lijstE6)
        modelContext.insert(lijstE7)
        
        // Voeg de woorden toe aan de modelcontext.
        modelContext.insert(Woord.aap)
        modelContext.insert(Woord.noot)
        modelContext.insert(Woord.mies)
        modelContext.insert(Woord.manden)
        modelContext.insert(Woord.ballen)
        modelContext.insert(Woord.balen)
        modelContext.insert(Woord.fietsje)
        modelContext.insert(Woord.gebakken)
        modelContext.insert(Woord.gapen)
        modelContext.insert(Woord.weken)
        modelContext.insert(Woord.wekken)
        modelContext.insert(Woord.werken)
        modelContext.insert(Woord.kip)
        
        // Koppel de woorden aan de juiste lijst.
        Woord.aap.lijst = lijstM3
        Woord.noot.lijst = lijstE3
        Woord.mies.lijst = lijstM4
        Woord.manden.lijst = lijstE4
        Woord.balen.lijst = lijstM5
        Woord.ballen.lijst = lijstE5
        Woord.fietsje.lijst = lijstM6
        Woord.gapen.lijst = lijstE6
        Woord.weken.lijst = lijstM7
        Woord.wekken.lijst = lijstE7
        Woord.werken.lijst = lijst8plus
        Woord.kip.lijst = lijstE3
        Woord.gebakken.lijst = lijstE4
    }
    
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Lijst.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
