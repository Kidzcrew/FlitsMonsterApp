import Foundation

struct AppSettings {
    // Keys for @AppStorage
    static let standaardGroepKey = "GeselecteerdeGroep"
    static let taalKey = "userLanguage"
    
    // Standaardwaarden
    static let standaardGroep = "Alle lijsten"
    static let standaardTaal: AppLanguage = .nl // Default language is Dutch

    // Enum to manage the language options
    enum AppLanguage: String {
        case nl = "nl"  // Dutch
        case en = "en"  // English
    }
}
