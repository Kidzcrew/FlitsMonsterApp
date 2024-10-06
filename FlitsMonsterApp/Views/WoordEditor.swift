import SwiftUI
import SwiftData

struct WoordEditor: View {
    var woord: Woord?
    let lijst: Lijst
    @Binding var woorden: [Woord] // Binding voor de woordenlijst

    @State private var naam = ""
    @State private var woordSoort = Woord.Soort.letterdief
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var woordBestaatInAndereLijst = false
    @State private var bestaandeLijsten: [Lijst] = []
    @State private var woordZitAlInHuidigeLijst = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                TextField("Naam", text: $naam)
                    .autocapitalization(.none) // Voorkomt automatisch hoofdlettergebruik
                    .textInputAutocapitalization(.never) // Werkt in iOS 15 en hoger
                
                Picker("Woordsoort", selection: $woordSoort) {
                    ForEach(Woord.Soort.allCases, id: \.self) { soort in
                        Text(soort.rawValue).tag(soort)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(woord == nil ? "Voeg woord toe" : "Wijzig woord")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Bewaar") {
                        withAnimation {
                            validateWoordBeforeSave()
                        }
                    }
                    .disabled(naam.isEmpty) // Disable save button if naam is empty
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let woord = woord {
                    // Bewerk het bestaande woord
                    naam = woord.naam
                    woordSoort = woord.soort
                }
            }
            .alert(isPresented: $showAlert) {
                if woordBestaatInAndereLijst {
                    return Alert(
                        title: Text("Woord al in andere lijst"),
                        message: Text("Dit woord zit al in lijst(en): \(bestaandeLijsten.map { $0.naam }.joined(separator: ", ")). Wil je het woord hier ook toevoegen?"),
                        primaryButton: .default(Text("Ja")) {
                            addWoordToCurrentList()
                            dismiss() // Sluit de editor
                        },
                        secondaryButton: .cancel(Text("Nee"))
                    )
                } else if woordZitAlInHuidigeLijst {
                    return Alert(
                        title: Text("Woord al in deze lijst"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK")) {
                            dismiss() // Sluit de editor na OK
                        }
                    )
                } else {
                    return Alert(
                        title: Text("Fout"),
                        message: Text("Er is een onverwachte fout opgetreden."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }

    private func validateWoordBeforeSave() {
        bestaandeLijsten = []
        woordZitAlInHuidigeLijst = false
        
        let bestaandeWoorden = try! modelContext.fetch(FetchDescriptor<Woord>(predicate: #Predicate {
            $0.naam == naam
        }))
        
        if let bestaandWoord = bestaandeWoorden.first {
            if bestaandWoord.lijsten.contains(lijst) {
                alertMessage = "Dit woord zit al in deze lijst."
                woordZitAlInHuidigeLijst = true
                showAlert = true
            } else {
                bestaandeLijsten = bestaandWoord.lijsten
                woordBestaatInAndereLijst = true
                showAlert = true
            }
        } else {
            save()
            dismiss()
        }
    }

    private func addWoordToCurrentList() {
        if let bestaandWoord = try? modelContext.fetch(FetchDescriptor<Woord>(predicate: #Predicate {
            $0.naam == naam
        })).first {
            bestaandWoord.lijsten.append(lijst)
            woorden.append(bestaandWoord) // Update de woordenlijst binding
        }
    }

    /// Sla het woord op, als nieuw of bewerk het bestaande
    private func save() {
        if let woord = woord {
            // Bewerk het bestaande woord
            woord.naam = naam
            woord.soort = woordSoort
            if !woord.lijsten.contains(lijst) {
                woord.lijsten.append(lijst) // Voeg de huidige lijst toe
            }
        } else {
            // Voeg een nieuw woord toe aan de gegeven lijst
            let nieuwWoord = Woord(naam: naam, soort: woordSoort, lijsten: [lijst])
            modelContext.insert(nieuwWoord)
            woorden.append(nieuwWoord) // Update de woordenlijst binding
        }
    }
}

#Preview("Voeg woord toe") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordEditor(woord: nil, lijst: .lijstM3, woorden: .constant([])) // De lijst wordt nu meegegeven
    }
}

#Preview("Bewerk woord") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordEditor(woord: .kip, lijst: .lijstM3, woorden: .constant([])) // Bewerk een woord binnen een specifieke lijst
    }
}
