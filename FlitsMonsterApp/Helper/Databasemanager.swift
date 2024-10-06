import SwiftData
import SwiftUI

// Struct om de JSON-data te representeren
struct StandaardLijst: Codable {
    let niveau: String
    let naam: String
    let beschrijving: String
    let woorden: [String]
    let icoon: String
}

// Functie om de JSON-data te laden en om te zetten naar een array van StandaardLijst structs
func voegStandaardLijstenToeVanuitJSON(context: ModelContext) {
    let standaardLijsten = laadStandaardLijsten()
    
    for lijstInfo in standaardLijsten {
        // Controleer of de lijst al bestaat
        let bestaandeLijsten = try! context.fetch(FetchDescriptor<Lijst>(predicate: #Predicate {
            $0.naam == lijstInfo.naam
        }))
        
        if bestaandeLijsten.isEmpty {
            // Voeg de nieuwe lijst toe
            guard let niveau = Lijst.Niveau(rawValue: lijstInfo.niveau) else {
                print("Ongeldig niveau voor lijst: \(lijstInfo.naam)")
                continue
            }
            
            let nieuweLijst = Lijst(naam: lijstInfo.naam, beschrijving: lijstInfo.beschrijving, niveau: niveau, icoon: lijstInfo.icoon)
            context.insert(nieuweLijst)
            
            // Voeg de woorden toe aan de nieuwe lijst
            for woordNaam in lijstInfo.woorden {
                let bestaandeWoorden = try! context.fetch(FetchDescriptor<Woord>(predicate: #Predicate {
                    $0.naam == woordNaam
                }))
                
                let nieuwWoord: Woord
                if bestaandeWoorden.isEmpty {
                    // Maak een nieuw woord en koppel het aan de lijst
                    nieuwWoord = Woord(naam: woordNaam, soort: .hoorman, lijsten: [nieuweLijst])
                    context.insert(nieuwWoord)
                } else {
                    // Het woord bestaat al, voeg de lijst toe aan de lijsten van het bestaande woord
                    nieuwWoord = bestaandeWoorden.first!
                    nieuwWoord.lijsten.append(nieuweLijst)
                }
                
                // Voeg het woord toe aan de lijst
                nieuweLijst.woorden.append(nieuwWoord)
            }
        } else {
            print("Lijst '\(lijstInfo.naam)' bestaat al.")
        }
    }

    // Sla de wijzigingen op
    do {
        try context.save()
    } catch {
        print("Fout tijdens het opslaan van standaardlijsten vanuit JSON: \(error)")
    }
}

// Functie om JSON-bestand te laden en om te zetten naar een array van StandaardLijst
func laadStandaardLijsten() -> [StandaardLijst] {
    // Controleer of het JSON-bestand in de bundel zit
    guard let url = Bundle.main.url(forResource: "standaardlijsten", withExtension: "json") else {
        print("Kon het standaardlijsten JSON-bestand niet vinden.")
        return []
    }
    
    do {
        // Lees de data van het JSON-bestand
        let data = try Data(contentsOf: url)
        // Decodeer de JSON naar het StandaardLijst-model
        let decoder = JSONDecoder()
        let lijsten = try decoder.decode([StandaardLijst].self, from: data)
        return lijsten
    } catch {
        print("Fout bij het laden van JSON: \(error)")
        return []
    }
}
