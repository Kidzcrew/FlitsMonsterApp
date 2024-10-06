import Foundation
import SwiftData

@Model
final class Lijst {
    @Attribute(.unique) var naam: String
    var beschrijving: String = "voeg beschrijving toe"
    var niveau: Niveau? // Enum voor niveau (zoals je al hebt)
    
    // Nieuwe attributen toegevoegd voor de presentatie
    var voortgang: Int = 0 // Standaard voortgang
    var kleurPrimair: String = "#FFFFFF" // Standaard primaire kleur (wit)
    var kleurSecundair: String = "#000000" // Standaard secundaire kleur (zwart)
    var icoon: String = "star" // Standaard icoon (ster)
    var isFavoriet: Bool

    @Relationship(deleteRule: .cascade, inverse: \Woord.lijsten)
    var woorden: [Woord]
    
    init(naam: String, beschrijving: String = "", niveau: Niveau? = nil, voortgang: Int = 0, kleurPrimair: String = "#FFFFFF", kleurSecundair: String = "#000000", icoon: String = "monster1", isFavoriet: Bool = false, woorden: [Woord] = []) {
        self.naam = naam
        self.beschrijving = beschrijving
        self.niveau = niveau
        self.voortgang = voortgang
        self.kleurPrimair = kleurPrimair
        self.kleurSecundair = kleurSecundair
        self.icoon = icoon
        self.isFavoriet = false
        self.woorden = woorden
    }
}

// Enum voor niveau
extension Lijst {
    enum Niveau: String, CaseIterable, Codable {
        case S
        case M3
        case E3
        case M4
        case E4
        case M5
        case E5
        case M6
        case E6
        case M7
        case E7
        case eightPlus = "8plus"
        case eigen = "eigen lijst"
    }
}
