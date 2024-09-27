//
//  NieuweLijstFormulier.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 27/09/2024.
//
/*

import SwiftUI

struct NieuweLijstFormulier: View {
    @Binding var lijstNaam: String
    @Binding var geselecteerdNiveau: Niveau
    @Binding var lijstOmschrijving: String

    var addItem: () -> Void // Functie om een nieuwe lijst toe te voegen

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Lijstgegevens")) {
                    TextField("Lijstnaam", text: $lijstNaam)
                    
                    Picker("Niveau", selection: $geselecteerdNiveau) {
                        ForEach(Niveau.allCases, id: \.self) { niveau in
                            Text(niveau.rawValue).tag(niveau)
                        }
                    }
                    
                    TextField("Omschrijving", text: $lijstOmschrijving)
                }

                Button("Voeg Lijst Toe") {
                    addItem()
                    dismiss() // Sluit het formulier na het toevoegen
                }
                .disabled(lijstNaam.isEmpty || lijstOmschrijving.isEmpty) // Zorg dat de knop is uitgeschakeld als velden leeg zijn
            }
            .navigationTitle("Nieuwe Lijst")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuleer") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NieuweLijstFormulier(
        lijstNaam: .constant("Voorbeeldlijst"),
        geselecteerdNiveau: .constant(.S),
        lijstOmschrijving: .constant("Een voorbeeldomschrijving"),
        addItem: {
            print("Voorbeeld lijst toegevoegd.")
        }
    )
}
 */
