import SwiftUI

@main
struct FlitsMonsterAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
        .modelContainer(for: [Lijst.self, Woord.self]) // Voeg meerdere modellen toe
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}

