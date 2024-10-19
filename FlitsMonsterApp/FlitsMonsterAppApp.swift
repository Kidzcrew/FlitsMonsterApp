import SwiftUI

@main
struct FlitsMonsterAppApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // Apply dark or light mode globally
            
            
        }
        .modelContainer(for: [Lijst.self, Woord.self]) // Voeg meerdere modellen toe
        #if os(macOS)
        .commands {
            SidebarCommands()
        }
        #endif
    }
}

