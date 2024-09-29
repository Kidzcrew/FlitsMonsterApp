//
//  LijstEditor.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 28/09/2024.
//


import SwiftUI
import SwiftData

struct LijstEditor: View {
    let lijst: Lijst?

    @State private var naam = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Lijstnaam", text: $naam)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(lijst == nil ? "Voeg lijst toe" : "Bewerk lijst")
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Opslaan") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    .disabled(naam.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer", role: .cancel) {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let lijst {
                    naam = lijst.naam
                }
            }
        }
    }

    private func save() {
        if let lijst {
            lijst.naam = naam
        } else {
            // Voeg een nieuwe lijst toe
            let nieuweLijst = Lijst(naam: naam)
            modelContext.insert(nieuweLijst)
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
