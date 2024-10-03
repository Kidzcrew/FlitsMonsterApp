import SwiftUI
import SwiftData

struct LijstenView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Lijst.naam) private var woordLijsten: [Lijst]
    @State private var isReloadPresented = false
    @State private var geselecteerdeGroep: String = AppSettings.getGeselecteerdeGroep() // Haal geselecteerde groep op

    let alleGroepen = ["Alle lijsten", "Groep 3", "Groep 4", "Groep 5", "Groep 6", "Groep 7", "Groep 8"]

    var gefilterdeLijsten: [Lijst] {
        if geselecteerdeGroep != "Alle lijsten" {
            return filterLijstenOpGroep(geselecteerdeGroep)
        } else {
            return woordLijsten
        }
    }

    var body: some View {
        @Bindable var navigationContext = navigationContext
        VStack {
            HStack {
                Text("Filter op groep:")
                Menu {
                    ForEach(alleGroepen, id: \.self) { groep in
                        Button(groep) {
                            geselecteerdeGroep = groep
                            AppSettings.setGeselecteerdeGroep(groep) // Sla geselecteerde groep op
                            print("Geselecteerde groep: \(groep)") // Print de geselecteerde groep
                        }
                    }
                } label: {
                    Label(geselecteerdeGroep, systemImage: "line.horizontal.3.decrease.circle")
                }
                Spacer()
            }
            .padding()

            List(selection: $navigationContext.selectedLijst) {
                #if os(macOS)
                Section(navigationContext.sidebarTitle) {
                    ListCategories(woordLijsten: gefilterdeLijsten)
                }
                #else
                ListCategories(woordLijsten: gefilterdeLijsten)
                #endif
            }
        }
        .alert("Reload Sample Data?", isPresented: $isReloadPresented) {
            Button("Yes, reload sample data", role: .destructive) {
                reloadSampleData()
            }
        } message: {
            Text("Reloading the sample data deletes all changes to the current data.")
        }
        .toolbar {
            Button {
                isReloadPresented = true
            } label: {
                Label("", systemImage: "arrow.clockwise")
                    .help("Reload sample data")
            }
        }
        .task {
            if woordLijsten.isEmpty {
                print("woordenlijst is leeg - sample gebruikt")
                Lijst.insertSampleData(modelContext: modelContext)
            }
        }
    }

    @MainActor
    private func reloadSampleData() {
        navigationContext.selectedWoord = nil
        navigationContext.selectedLijst = nil
        Lijst.reloadSampleData(modelContext: modelContext)
    }

    private func filterLijstenOpGroep(_ groep: String) -> [Lijst] {
        switch groep {
        case "Groep 3":
            return woordLijsten.filter { ["S", "M3", "E3"].contains($0.niveau?.rawValue ?? "") }
        case "Groep 4":
            return woordLijsten.filter { ["E3", "M4", "E4"].contains($0.niveau?.rawValue ?? "") }
        case "Groep 5":
            return woordLijsten.filter { ["E4", "M5", "E5"].contains($0.niveau?.rawValue ?? "") }
        case "Groep 6":
            return woordLijsten.filter { ["E5", "M6", "E6"].contains($0.niveau?.rawValue ?? "") }
        case "Groep 7":
            return woordLijsten.filter { ["E6", "M7", "E7"].contains($0.niveau?.rawValue ?? "") }
        case "Groep 8":
            return woordLijsten.filter { ["E7", "8+"].contains($0.niveau?.rawValue ?? "") }
        default:
            return woordLijsten
        }
    }
}

private struct ListCategories: View {
    var woordLijsten: [Lijst]

    var body: some View {
        ForEach(woordLijsten) { lijst in
            NavigationLink(lijst.naam, value: lijst)
        }
    }
}

#Preview("LijstenView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            LijstenView()
        }
        .environment(NavigationContext())
    }
}

#Preview("WoordLijsten") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            List {
                ListCategories(woordLijsten: [.lijstE3, .lijstE4])
            }
        }
        .environment(NavigationContext())
    }
}
