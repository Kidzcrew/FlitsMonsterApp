

import SwiftUI
import SwiftData

struct WoordEditor: View {
    let woord: Woord?
    
    private var editorTitle: String {
        woord == nil ? "Voeg woord toe" : "Wijzig woord"
    }
    
    @State private var naam = ""
    @State private var woordSoort = Woord.Soort.letterdief
    @State private var geselecteerdeLijst: Lijst?
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Lijst.naam) private var lijsten: [Lijst]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("naam", text: $naam)
                
                Picker("Lijst", selection: $geselecteerdeLijst) {
                    Text("Select a Lijst").tag(nil as Lijst?)
                    ForEach(lijsten) { lijst in
                        Text(lijst.naam).tag(lijst as Lijst?)
                    }
                }
                
                Picker("Woordsoort", selection: $woordSoort) {
                    ForEach(Woord.Soort.allCases, id: \.self) { soort in
                        Text(soort.rawValue).tag(soort)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bewaar") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    // Require a category to save changes.
                    .disabled($geselecteerdeLijst.wrappedValue == nil)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let woord {
                    // Edit the incoming woord.
                    naam = woord.naam
                    woordSoort = woord.soort
                    geselecteerdeLijst = woord.lijst
                }
            }
            #if os(macOS)
            .padding()
            #endif
        }
    }
    
    private func save() {
        if let woord {
            // Edit the woord.
            woord.naam = naam
            woord.soort = woordSoort
            woord.lijst = geselecteerdeLijst
        } else {
            // Voeg een woord toe.
            let nieuwWoord = Woord(naam: naam, soort: woordSoort)
            nieuwWoord.lijst = geselecteerdeLijst
            modelContext.insert(nieuwWoord)
        }
    }
}

#Preview("Voeg woord toe") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordEditor(woord: nil)
    }
}

#Preview("Bewerk woord") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordEditor(woord: .kip)
    }
}
