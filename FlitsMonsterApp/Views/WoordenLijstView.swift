/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays a list of woorden.
*/

import SwiftUI
import SwiftData

struct WoordenLijstView: View {
    let woordLijstNaam: String?
    
    var body: some View {
        if let woordLijstNaam {
            WoordLijst(lijstNaam: woordLijstNaam)
        } else {
            ContentUnavailableView("Select a category", systemImage: "sidebar.left")
        }
    }
}

private struct WoordLijst: View {
    let lijstNaam: String
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Woord.naam) private var woorden: [Woord]
    @State private var isEditorPresented = false

    init(lijstNaam: String) {
        self.lijstNaam = lijstNaam
        let predicate = #Predicate<Woord> { woord in
            woord.lijst?.naam == lijstNaam
        }
        _woorden = Query(filter: predicate, sort: \Woord.naam)
    }
    
    var body: some View {
        @Bindable var navigationContext = navigationContext
        List(selection: $navigationContext.selectedWoord) {
            ForEach(woorden) { woord in
                NavigationLink(woord.naam, value: woord)
            }
            .onDelete(perform: verwijderWoorden)
        }
        .sheet(isPresented: $isEditorPresented) {
            WoordEditor(woord: nil)
        }
        .overlay {
            if woorden.isEmpty {
                ContentUnavailableView {
                    Label("Geen Woorden in deze lijst", systemImage: "pawprint")
                } description: {
                    AddWoordButton(isActive: $isEditorPresented)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                AddWoordButton(isActive: $isEditorPresented)
            }
        }
    }
    
    private func verwijderWoorden(at indexSet: IndexSet) {
        for index in indexSet {
            let woordToDelete = woorden[index]
            if navigationContext.selectedWoord?.persistentModelID == woordToDelete.persistentModelID {
                navigationContext.selectedWoord = nil
            }
            modelContext.delete(woordToDelete)
        }
    }
}

private struct AddWoordButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("voeg een woord toe", systemImage: "plus")
                .help("Voeg woord toe")
        }
    }
}

#Preview("WoordenLijstView") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            WoordenLijstView(woordLijstNaam: Lijst.lijstE3.naam)
                .environment(NavigationContext())
        }
    }
}

#Preview("geen lijst geselecteerd") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordenLijstView(woordLijstNaam: nil)
    }
}

#Preview("Geen woorden") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordLijst(lijstNaam: Lijst.lijstM5.naam)
            .environment(NavigationContext())
    }
}

#Preview("AddWoordButton") {
    AddWoordButton(isActive: .constant(false))
}