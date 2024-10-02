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
                    .navigationTitle(selectedLijst.naam)
            } else {
                Text("Selecteer een lijst")
            }
        } detail: {
            // Detailweergave voor geselecteerd woord
            if let selectedWoord = navigationContext.selectedWoord {
                WoordDetailView(woord: selectedWoord)
                    .navigationTitle(selectedWoord.naam)
                    .onAppear {
                        // Sluit de zijbalk en content view als een woord is geselecteerd
                        navigationContext.columnVisibility = .detailOnly
                    }
            } else {
                Text("Selecteer een woord")
            }
        }
        .onChange(of: navigationContext.selectedWoord) { _ in
            // Elke keer als een nieuw woord wordt geselecteerd, verberg de zijbalk en content view
            if navigationContext.selectedWoord != nil {
                navigationContext.columnVisibility = .detailOnly
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
