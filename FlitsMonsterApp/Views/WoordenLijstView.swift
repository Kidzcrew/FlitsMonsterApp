import SwiftUI
import SwiftData

// Mock-up NavigationContext for Preview purposes
class MockNavigationContext: ObservableObject {
    @Published var selectedWoord: Woord?
}

struct WoordenLijstView: View {
    let lijst: Lijst?
    
    var body: some View {
        if let lijst = lijst {
            WoordLijst(lijst: lijst)
        } else {
            ContentUnavailableView("Select a category", systemImage: "sidebar.left")
        }
    }
}

private struct WoordLijst: View {
    let lijst: Lijst
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Woord.naam) private var woorden: [Woord]
    @State private var isEditorPresented = false
    
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
        .padding()
        .navigationTitle(lijst.naam)
        
            Text("Niveau: \(lijst.niveau?.rawValue ?? "Onbekend")")
                .font(.subheadline)
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
            WoordenLijstView(lijst: Lijst.lijstE3)
                .environment(NavigationContext())
        }
    }
}

#Preview("geen lijst geselecteerd") {
    ModelContainerPreview(ModelContainer.sample) {
        WoordenLijstView(lijst: nil)
    }
}
