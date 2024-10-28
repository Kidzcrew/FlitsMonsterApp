import SwiftUI
import SwiftData

struct ThreeColumnContentView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigationContext = navigationContext
        NavigationSplitView(columnVisibility: $navigationContext.columnVisibility) {
            // Sidebar voor de lijsten
            LijstenView()
                .navigationTitle(navigationContext.sidebarTitle)
        } content: {
            // Content weergave voor geselecteerde lijst
            if let selectedLijst = navigationContext.selectedLijst {
                WoordenLijstView(lijst: selectedLijst)
            } else {
                Text("Selecteer een lijst")
            }
        } detail: {
            // Empty detail pane to prevent direct navigation to WoordDetailView
            Text("Selecteer een woord om te bekijken in WoordenLijstView")
                .foregroundColor(.gray)
        }
        .onChange(of: navigationContext.selectedWoord) {
            // Update selected word but do not navigate to a separate detail view
            if navigationContext.selectedWoord != nil {
                // Optionally reset to show all columns, or adjust based on app design
                navigationContext.columnVisibility = .all
            }
        }
        .onAppear {
            // Zorg ervoor dat de kolomzichtbaarheid is ingesteld op alle kolommen (sidebar + detail) bij de start
            if navigationContext.selectedLijst == nil {
                navigationContext.columnVisibility = .all
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ThreeColumnContentView()
            .environment(NavigationContext())
    }
}
