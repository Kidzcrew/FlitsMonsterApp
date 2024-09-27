import XCTest
import SwiftData
@testable import FlitsMonsterApp

final class FlitsMonsterAppTests: XCTestCase {

    var modelContainer: ModelContainer?
    var context: ModelContext?

    override func setUpWithError() throws {
        // Initialiseer het schema met je modellen
        let schema = Schema([Lijst.self, Woord.self])

        // Maak de ModelContainer met het schema (voor SwiftData-modellen)
        modelContainer = try ModelContainer(for: schema)

        // Gebruik MainActor.run om de context binnen de MainActor te initialiseren
        Task { @MainActor in
            // Haal de ModelContext op uit de ModelContainer
            context = modelContainer?.mainContext

            // Controleer of de context correct is geïnitialiseerd
            XCTAssertNotNil(context, "ModelContext is nil!")
        }
    }

    override func tearDownWithError() throws {
        // Opruimen na elke test
        Task { @MainActor in
            modelContainer = nil
            context = nil
        }
    }

    func testAddWordToLijst() throws {
        Task { @MainActor in
            // Zorg dat de context niet nil is
            guard let context = context else {
                XCTFail("ModelContext is nil")
                return
            }

            // Arrange: Maak een nieuwe lijst aan
            let lijst = Lijst(naam: "Testlijst")
            context.insert(lijst)

            // Act: Voeg een nieuw woord toe aan de lijst
            let woord = Woord(naam: "Testwoord", soort: .hoorman)
            woord.lijst = lijst
            context.insert(woord)

            // Assert: Controleer of het woord correct is toegevoegd aan de lijst
            XCTAssertEqual(lijst.woorden.count, 1)
            XCTAssertEqual(lijst.woorden.first?.naam, "Testwoord")
        }
    }
}
