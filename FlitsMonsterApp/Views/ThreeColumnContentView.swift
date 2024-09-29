import SwiftUI
import SwiftData

struct ThreeColumnContentView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigationContext = navigationContext
        NavigationSplitView(columnVisibility: $navigationContext.columnVisibility) {
            LijstenView() // Geeft de lijst-weergave
                .navigationTitle(navigationContext.sidebarTitle)
        } content: {
            if let selectedLijst = navigationContext.selectedLijst {
                WoordenLijstView(lijst: selectedLijst) // Doorgeven van de geselecteerde lijst
                    .navigationTitle(selectedLijst.naam) // Gebruik lijstnaam als titel
            } else {
                Text("Selecteer een lijst") // Als geen lijst is geselecteerd
            }
        } detail: {
            if let selectedWoord = navigationContext.selectedWoord {
                WoordDetailView(woord: selectedWoord) // Doorgeven van het geselecteerde woord
            } else {
                Text("Selecteer een woord") // Als geen woord is geselecteerd
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
