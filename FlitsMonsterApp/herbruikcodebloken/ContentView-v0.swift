//
//  ContentView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 27/09/2024.
//
/*

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext: ModelContext
    @Query(sort: \Lijst.timestamp, order: .forward) private var lijsten: [Lijst]
    
    @State private var geselecteerdeGroep: GroepFilter = .alle // Gebruik de enum voor de groepen
    @State private var lijstNaam = ""
    @State private var geselecteerdNiveau: Niveau = .S // Gebruik de Niveau enum
    @State private var lijstOmschrijving = ""
    @State private var showingNieuweLijstPopover = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#92DDED", alpha: 0.5)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Welkom bij Flitsmonster")
                        .bold()
                        .foregroundColor(.blue)
                        .padding()
                    
                    // Picker voor filteren van lijsten
                    HStack {
                        Text("Filter op groep:")
                            .foregroundColor(.white)
                        Picker("Filter", selection: $geselecteerdeGroep) {
                            ForEach(GroepFilter.allCases) { groep in
                                Text(groep.rawValue)
                                    .foregroundColor(.white)
                                    .tag(groep)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    
                    ScrollView {
                        VStack {
                            if filteredLijsten().isEmpty {
                                // Voeg een fallback toe als er geen lijsten zijn
                                Text("Geen lijsten beschikbaar")
                                    .foregroundColor(.red)
                                    .padding()
                            } else {
                                ScrollView {
                                    VStack {
                                        ForEach(filteredLijsten(), id: \.id) { lijst in
                                            LijstElementView(lijst: lijst)
                                        }
                                    }
                                    .padding()
                                }
                            }
                        }
                        .padding()
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingNieuweLijstPopover = true
                            }) {
                                Label("Nieuwe Lijst", systemImage: "plus")
                            }
                        }
                    }
                }
                .popover(isPresented: $showingNieuweLijstPopover) {
                    NieuweLijstFormulier(
                        lijstNaam: $lijstNaam,
                        geselecteerdNiveau: $geselecteerdNiveau,
                        lijstOmschrijving: $lijstOmschrijving,
                        addItem: addItem
                    )
                }
            }
        }
        .onAppear {
            // Seed initial data wanneer de view verschijnt
            seedInitialData(context: modelContext)
            print("ContentView is loaded and ModelContainer is being set up.")
        }
    }
    
    // Computed property voor gefilterde lijsten op basis van geselecteerde groep
    private func filteredLijsten() -> [Lijst] {
        let gefilterdeLijsten: [Lijst]
        
        if geselecteerdeGroep == .alle {
            gefilterdeLijsten = lijsten
        } else {
            gefilterdeLijsten = lijsten.filter { lijst in
                geselecteerdeGroep.bijbehorendeNiveaus.contains { $0.rawValue == lijst.niveau }
            }
        }
        
        print("Geselecteerde groep: \(geselecteerdeGroep)")
        print("Gefilterde lijsten: \(gefilterdeLijsten.map { $0.naam })")
        
        return gefilterdeLijsten
    }
    
    // Functie om een nieuwe lijst aan te maken
    private func addItem() {
        let info = geselecteerdNiveau.kleurenEnIconen()

        let nieuweLijst = Lijst(
            naam: lijstNaam,
            niveau: geselecteerdNiveau.rawValue,
            omschrijving: lijstOmschrijving,
            timestamp: Date(),
            voortgang: 0,
            kleurPrimair: info.primair,
            kleurSecundair: info.secundair,
            icoon: info.lijstMonster,
            woordenInLijst: []
        )

        let woorden = ["kip", "paard", "aap"].map { woordNaam in
            Woord(naam: woordNaam) // Gebruik een array voor veel-op-veel relatie
        }

        nieuweLijst.woordenInLijst.append(contentsOf: woorden) // Geen optionele check meer nodig

        modelContext.insert(nieuweLijst)

        do {
            try modelContext.save()
            print("Nieuwe lijst succesvol opgeslagen.")
        } catch {
            print("Fout bij het opslaan van de context: \(error)")
        }
    }
    
    // Seeder functie om voorbeelddata in te voegen
    private func seedInitialData(context: ModelContext) {
        let fetchDescriptor = FetchDescriptor<Lijst>()
        
        do {
            let lijsten = try context.fetch(fetchDescriptor)
            
            if lijsten.isEmpty {
                let voorbeeldLijst = Lijst(
                    naam: "Voorbeeldlijst",
                    niveau: "M3",
                    omschrijving: "Voorbeeldlijst met woorden",
                    timestamp: Date(),
                    voortgang: 0,
                    kleurPrimair: "#FF512F",
                    kleurSecundair: "#1BFFFF",
                    icoon: "Monster4",
                    woordenInLijst: []
                )

                let woorden = ["kat", "rat", "muis"].map { woordNaam in
                    Woord(naam: woordNaam)
                }

                voorbeeldLijst.woordenInLijst.append(contentsOf: woorden)

                context.insert(voorbeeldLijst)

                do {
                    try context.save()
                    print("Voorbeelddata succesvol ingevoegd.")
                } catch {
                    print("Fout bij het invoegen van voorbeelddata: \(error)")
                }
            }
        } catch {
            print("Fout bij het ophalen van lijsten: \(error)")
        }
    }
    struct LijstElementView: View {
        let lijst: Lijst
        
        var body: some View {
            let info = Niveau(rawValue: lijst.niveau)?.kleurenEnIconen()
            
            NavigationLink(destination: WoordenLijstView(lijst: lijst)) {
                LijstElement(lijst: lijst) // Geef het volledige 'lijst'-object door
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    let previewContainer: ModelContainer = {
        do {
            // In-memory storage for previews, avoiding file-based persistence
            return try ModelContainer(for: Lijst.self, configurations: .init(isStoredInMemoryOnly: true))
        } catch {
            fatalError("Failed to create preview ModelContainer: \(error)")
        }
    }()

    ContentView()
        .modelContainer(previewContainer)
}

*/
