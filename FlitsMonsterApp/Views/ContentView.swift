import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationContext = NavigationContext()
    @Environment(\.modelContext) private var modelContext  // Haal de modelContext op uit de omgeving
    
    var body: some View {
        ThreeColumnContentView()
            .environment(navigationContext)
            .onAppear {
                // Voer de migratie uit zodra de view verschijnt
                migrateDataIfNeeded(context: modelContext)
                // Voeg standaardlijsten toe vanuit JSON
                voegStandaardLijstenToeVanuitJSON(context: modelContext)
            }
    }

    // Migratiefunctie om ontbrekende niveau's toe te voegen
    func migrateDataIfNeeded(context: ModelContext) {
        // Fetch alle Lijst-objecten via SwiftData
        let lijsten = try! context.fetch(FetchDescriptor<Lijst>())
        
        // Controleer of de lijsten een standaardniveau hebben, en wijs zo nodig een standaardwaarde toe
        for lijst in lijsten {
            if lijst.niveau == .S {  // Stel bijvoorbeeld alleen in als het niveau een specifieke waarde heeft
                lijst.niveau = .S  // Standaardwaarde voor lijsten die geen niveau hebben
            }
        }
        
        // Sla de wijzigingen op
        do {
            try context.save()
        } catch {
            print("Fout tijdens het opslaan van gemigreerde data: \(error)")
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
