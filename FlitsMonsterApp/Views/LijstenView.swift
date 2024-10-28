import SwiftUI
import SwiftData

struct LijstenView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Lijst.naam) private var woordLijsten: [Lijst]
    @AppStorage(AppSettings.standaardGroepKey) private var geselecteerdeGroep: String = AppSettings.standaardGroep

    let alleGroepen = ["Alle lijsten", "Groep 3", "Groep 4", "Groep 5", "Groep 6", "Groep 7", "Groep 8"]

    var gefilterdeLijsten: [Lijst] {
        if geselecteerdeGroep != "Alle lijsten" {
            return filterLijstenOpGroep(geselecteerdeGroep)
        } else {
            return woordLijsten
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Filter op groep:")
                    Menu {
                        ForEach(alleGroepen, id: \.self) { groep in
                            Button(groep) {
                                geselecteerdeGroep = groep
                            }
                        }
                    } label: {
                        Label(geselecteerdeGroep, systemImage: "line.horizontal.3.decrease.circle")
                    }
                    Spacer()
                }
                .padding()

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(gefilterdeLijsten) { lijst in
                            LijstElement(lijst: lijst)
                                .onTapGesture {
                                    // Stel de geselecteerde lijst in via de NavigationContext
                                    navigationContext.selectedLijst = lijst
                                    print("Navigated to WoordenLijstView with lijst: \(lijst.naam)") // Debug print
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }

            .task {
                if woordLijsten.isEmpty {
                    Lijst.insertSampleData(modelContext: modelContext)
                }
            }
            .navigationDestination(for: Lijst.self) { lijst in
                WoordenLijstView(lijst: lijst) // Gebruik de LijstDetailView hier
                
            }
        }
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
