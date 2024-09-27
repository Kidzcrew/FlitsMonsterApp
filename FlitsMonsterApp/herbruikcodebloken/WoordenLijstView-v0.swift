//
//  WoordenLijstView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 27/09/2024.
//
/*

import SwiftUI
import SwiftData

struct WoordenLijstView: View {
    var lijst: Lijst // Ontvangt het volledige Lijst-object

    var body: some View {
        VStack {
            Text("Woorden in \(lijst.naam)")
                .font(.largeTitle)
                .bold()
                .padding()

            if lijst.woordenInLijst.isEmpty {
                Text("Geen woorden beschikbaar")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List {
                    ForEach(lijst.woordenInLijst, id: \.id) { woord in
                        HStack {
                            Text(woord.naam)
                                .font(.title2)
                            Spacer()
                            Text("In \(woord.zitInLijsten.count) lijsten")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle(lijst.naam)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    print("Nieuwe woord toevoegen")
                }) {
                    Label("Woord toevoegen", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    // Voorbeeldwoorden om in de preview te gebruiken
    let voorbeeldWoorden = [
        Woord(naam: "Kip", zitInLijsten: []),
        Woord(naam: "Paard", zitInLijsten: []),
        Woord(naam: "Aap", zitInLijsten: [])
    ]
    
    // Voorbeeldlijst voor de preview
    let voorbeeldLijst = Lijst(
        naam: "Voorbeeldlijst",
        niveau: "M3",
        omschrijving: "Een lijst met voorbeeldwoorden",
        timestamp: Date(),
        voortgang: 50,
        kleurPrimair: "#FF512F",
        kleurSecundair: "#1BFFFF",
        icoon: "star",
        woordenInLijst: voorbeeldWoorden
    )
    
    WoordenLijstView(lijst: voorbeeldLijst)
}
*/
