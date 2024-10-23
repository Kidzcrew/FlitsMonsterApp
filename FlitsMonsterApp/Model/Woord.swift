import Foundation
import SwiftData

@Model
final class Woord: Identifiable {
    var id = UUID()
    var naam: String
    var soort: Soort
    var lijsten: [Lijst]
    
    var isActive: Bool = true
    var isBookmarked: Bool = false

    // Practice states as raw string values
    @Attribute var practice1: String = "New"
    @Attribute var practice2: String = "New"
    @Attribute var practice3: String = "New"
    @Attribute var practice4: String = "New"
    @Attribute var practice5: String = "New"

    // Initializer
    init(naam: String, soort: Soort, lijsten: [Lijst]) {
        self.naam = naam
        self.soort = soort
        self.lijsten = lijsten
    }
}

extension Woord {
    // Enum for the practice states
    enum PracticeState: String, CaseIterable, Codable {
        case new = "New"
        case slow = "Slow"
        case morePractice = "MorePractice"
        case known = "Known"

        // Helper to get an enum from a string
        static func fromString(_ value: String) -> PracticeState {
            return PracticeState(rawValue: value) ?? .new
        }
    }

    // Enum for word type
    enum Soort: String, CaseIterable, Codable {
        case hoorman = "Hoorman"
        case letterzetter = "Letterzetter"
        case letterdief = "Letterdief"
    }
}
