import Foundation
import SwiftData

extension Lijst {
    static let lijstM3 = Lijst(naam: "lijst groep 3 Start", beschrijving: "Lijst voor groep 3", niveau: .M3, icoon: "monster1")
    static let lijstM4 = Lijst(naam: "lijst groep 4", beschrijving: "Lijst voor groep 4", niveau: .M4, icoon: "monster1")
    static let lijstM5 = Lijst(naam: "lijst groep 5", beschrijving: "Lijst voor groep 5", niveau: .M5, icoon: "monster2")
    static let lijstM6 = Lijst(naam: "lijst groep 6", beschrijving: "Lijst voor groep 6", niveau: .M6, icoon: "monster3")
    static let lijstM7 = Lijst(naam: "lijst groep 7", beschrijving: "Lijst voor groep 7", niveau: .M7, icoon: "monster4")
    static let lijst8plus = Lijst(naam: "lijst groep 8", beschrijving: "Lijst voor groep 8", niveau: .eightPlus, icoon: "monster5")
    static let lijstE3 = Lijst(naam: "lijst groep 3 Eind", beschrijving: "Eindlijst voor groep 3", niveau: .E3, icoon: "monster6")
    static let lijstE4 = Lijst(naam: "lijst groep 4 Eind", beschrijving: "Eindlijst voor groep 4", niveau: .E4, icoon: "monster7")
    static let lijstE5 = Lijst(naam: "lijst groep 5 Eind", beschrijving: "Eindlijst voor groep 5", niveau: .E5, icoon: "monster8")
    static let lijstE6 = Lijst(naam: "lijst groep 6 Eind", beschrijving: "Eindlijst voor groep 6", niveau: .E6, icoon: "monster9")
    static let lijstE7 = Lijst(naam: "lijst groep 7 Eind", beschrijving: "Eindlijst voor groep 7", niveau: .E7, icoon: "monster10")
    static let eigenlijst = Lijst(naam: "eigen lijst", beschrijving: "niveau niet bepaald", niveau: .eigen, icoon: "monster11")

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
        
        // Maak de woorden aan met bijbehorende lijsten.
        let aap = Woord(naam: "aap", soort: .hoorman, lijsten: [lijstM3])
        let noot = Woord(naam: "noot", soort: .letterzetter, lijsten: [lijstE3])
        let mies = Woord(naam: "mies", soort: .letterdief, lijsten: [lijstM4])
        let manden = Woord(naam: "manden", soort: .hoorman, lijsten: [lijstE4])
        let ballen = Woord(naam: "ballen", soort: .letterzetter, lijsten: [lijstE5])
        let balen = Woord(naam: "balen", soort: .letterdief, lijsten: [lijstM5])
        let fietsje = Woord(naam: "fietsje", soort: .hoorman, lijsten: [lijstM6])
        let gapen = Woord(naam: "gapen", soort: .letterdief, lijsten: [lijstE6])
        let weken = Woord(naam: "weken", soort: .letterdief, lijsten: [lijstM7])
        let wekken = Woord(naam: "wekken", soort: .letterzetter, lijsten: [lijstE7])
        let werken = Woord(naam: "werken", soort: .hoorman, lijsten: [lijst8plus])
        let kip = Woord(naam: "kip", soort: .hoorman, lijsten: [lijstE3])
        let gebakken = Woord(naam: "gebakken", soort: .letterzetter, lijsten: [lijstE4])

        // Voeg de woorden toe aan de modelcontext.
        modelContext.insert(aap)
        modelContext.insert(noot)
        modelContext.insert(mies)
        modelContext.insert(manden)
        modelContext.insert(ballen)
        modelContext.insert(balen)
        modelContext.insert(fietsje)
        modelContext.insert(gapen)
        modelContext.insert(weken)
        modelContext.insert(wekken)
        modelContext.insert(werken)
        modelContext.insert(kip)
        modelContext.insert(gebakken)

        // Koppel de woorden aan de juiste lijsten door ze aan beide zijden toe te voegen.
        lijstM3.woorden.append(aap)
        lijstE3.woorden.append(noot)
        lijstM4.woorden.append(mies)
        lijstE4.woorden.append(manden)
        lijstE5.woorden.append(ballen)
        lijstM5.woorden.append(balen)
        lijstM6.woorden.append(fietsje)
        lijstE6.woorden.append(gapen)
        lijstM7.woorden.append(weken)
        lijstE7.woorden.append(wekken)
        lijst8plus.woorden.append(werken)
        lijstE3.woorden.append(kip)
        lijstE4.woorden.append(gebakken)
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
