import SwiftData
import Foundation

@Model
final class Lijst: Identifiable, Hashable {
    var id = UUID()
    @Attribute(.unique) var naam: String
    var beschrijving: String = "voeg beschrijving toe"
    var niveau: Niveau? // Enum for the level (as already implemented)

    // Presentation attributes
    var voortgang: Int = 0 // Default progress
    var kleurPrimair: String = "#FFFFFF" // Default primary color (white)
    var kleurSecundair: String = "#000000" // Default secondary color (black)
    var icoon: String = "star" // Default icon (star)
    var isFavoriet: Bool
    var taal: Taal // Attribute for language distinction

    // New timestamp to track when the list was last used
    var lastUsed: Date? = nil

    @Relationship(deleteRule: .cascade, inverse: \Woord.lijsten)
    var woorden: [Woord]

    init(
        naam: String,
        beschrijving: String = "",
        niveau: Niveau? = nil,
        voortgang: Int = 0,
        kleurPrimair: String = "#FFFFFF",
        kleurSecundair: String = "#000000",
        icoon: String = "monster1",
        isFavoriet: Bool = false,
        taal: Taal = .nl,  // Default to Dutch language
        woorden: [Woord] = []
    ) {
        self.naam = naam
        self.beschrijving = beschrijving
        self.niveau = niveau
        self.voortgang = voortgang
        self.kleurPrimair = kleurPrimair
        self.kleurSecundair = kleurSecundair
        self.icoon = icoon
        self.isFavoriet = isFavoriet
        self.woorden = woorden
        self.taal = taal // Dynamically set language
        self.lastUsed = nil // Initially, the list hasn't been used
    }
}

// Enum voor niveau
extension Lijst {
    enum Niveau: String, CaseIterable, Codable {
        case S, M3, E3, M4, E4, M5, E5, M6, E6, M7, E7, eightPlus = "8plus", eigen = "eigen lijst"
    }
}

// Enum voor taal
extension Lijst {
    enum Taal: String, CaseIterable, Codable {
        case nl, en
    }
}
