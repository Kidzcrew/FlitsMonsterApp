import SwiftUI
import SwiftData

struct WoordDetailView: View {
    @Binding var woorden: [Woord] // Voeg een binding toe voor de woordenlijst
    var woord: Woord? // Het woord dat wordt weergegeven
    @State private var isEditing = false
    @State private var isDeleting = false
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.dismiss) private var dismiss // Voor het handmatig sluiten van de sheet

    var body: some View {
        if let woord {
            WoordDetailContentView(woord: woord)
                .navigationTitle("\(woord.naam)")
                .toolbar {
                    Button { isEditing = true } label: {
                        Label("Bewerk \(woord.naam)", systemImage: "pencil")
                            .help("Bewerk woord")
                    }

                    Button { isDeleting = true } label: {
                        Label("Verwijder \(woord.naam)", systemImage: "trash")
                            .help("Verwijder het woord")
                    }
                }
                .sheet(isPresented: $isEditing) {
                    // Gebruik de eerste lijst van het woord om door te geven aan de WoordEditor
                    if let eersteLijst = woord.lijsten.first {
                        WoordEditor(woord: woord, lijst: eersteLijst, woorden: $woorden) // Geef de woordenlijst door als binding
                    } else {
                        Text("Geen lijst gevonden")
                    }
                }
                .alert("Verwijder \(woord.naam)?", isPresented: $isDeleting) {
                    Button("Verwijder", role: .destructive) {
                        delete(woord)
                    }
                }
        } else {
            ContentUnavailableView("Kies een woord", systemImage: "pawprint")
        }
    }

    private func delete(_ woord: Woord) {
        navigationContext.selectedWoord = nil
        modelContext.delete(woord)
        if let index = woorden.firstIndex(of: woord) {
            woorden.remove(at: index) // Verwijder het woord uit de woordenlijst
        }
        // Sluit de sheet na het verwijderen van het woord
        dismiss()
    }
}

private struct WoordDetailContentView: View {
    let woord: Woord

    var body: some View {
        VStack {
            #if os(macOS)
            Text(woord.naam)
                .font(.title)
                .padding()
            #else
            EmptyView()
            #endif

            List {
                Section(header: Text("Lijsten")) {
                    ForEach(woord.lijsten, id: \.self) { lijst in
                        HStack {
                            Text(lijst.naam)
                            Spacer()
                        }
                    }
                }
                HStack {
                    Text("Soort")
                    Spacer()
                    Text(woord.soort.rawValue)
                }
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        WoordDetailView(woorden: .constant([.kip]), woord: .kip)
            .environment(NavigationContext())
    }
}
