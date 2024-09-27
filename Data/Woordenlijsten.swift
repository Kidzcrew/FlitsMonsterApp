//
//  Woordenlijsten.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

extension Lijst {
    static let lijstM3 = Lijst(naam: "lijst groep 3 Start")
    static let lijstM4 = Lijst(naam: "lijst groep 4")
    static let lijstM5 = Lijst(naam: "lijst groep 5")
    static let lijstM6 = Lijst(naam: "lijst groep 6")
    static let lijstM7 = Lijst(naam: "lijst groep 7")
    static let lijst8plus = Lijst(naam: "lijst groep 8")
    static let lijstE3 = Lijst(naam: "lijst groep 3 Eind")
    static let lijstE4 = Lijst(naam: "lijst groep 4 Eind")
    static let lijstE5 = Lijst(naam: "lijst groep 5 Eind")
    static let lijstE6 = Lijst(naam: "lijst groep 6 Eind")
    static let lijstE7 = Lijst(naam: "lijst groep 7 Eind")
  

    static func insertSampleData(modelContext: ModelContext) {
        // Add the Lijst categories to the model context.
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
        
        
        // Add the words to the model context.
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
        

        // Set the category for each word.
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

