import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationContext = NavigationContext()
    @Environment(\.modelContext) private var modelContext  // Fetch modelContext from environment
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environment(navigationContext)  // Pass navigation context to HomeView
            
            ThreeColumnContentView()
                .tabItem {
                    Label("Lijsten", systemImage: "list.bullet")
                }
                .environment(navigationContext)  // Pass navigation context to LijstenView
            
            NewsOverviewView()  
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
            
            InstellingenView() // Assume you have a settings view
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .onAppear {
            migrateDataIfNeeded(context: modelContext)
            voegStandaardLijstenToeVanuitJSON(context: modelContext)
        }
    }

    func migrateDataIfNeeded(context: ModelContext) {
        let lijsten = try! context.fetch(FetchDescriptor<Lijst>())
        for lijst in lijsten {
            if lijst.niveau == .S {
                lijst.niveau = .S  // Default value for lists with no level
            }
        }
        do {
            try context.save()
        } catch {
            print("Error saving migrated data: \(error)")
        }
    }
}

// Placeholder Views for News and Settings
struct NewsView: View {
    var body: some View {
        Text("News Articles")
    }
}


#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
