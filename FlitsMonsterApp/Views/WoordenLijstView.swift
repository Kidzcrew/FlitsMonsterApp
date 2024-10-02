import SwiftUI
import SwiftData

// Mock-up NavigationContext for Preview purposes
class MockNavigationContext: ObservableObject {
    @Published var selectedWoord: Woord?
}

struct WoordenLijstView: View {
    let lijst: Lijst?
    
    @State private var isLijstEditorPresented = false
    @State private var isVoortgangSheetPresented = false
    
    var body: some View {
        if let lijst = lijst {
            WoordLijst(lijst: lijst, isLijstEditorPresented: $isLijstEditorPresented, isVoortgangSheetPresented: $isVoortgangSheetPresented)
        } else {
            ContentUnavailableView("Select a category", systemImage: "sidebar.left")
        }
    }
}

private struct WoordLijst: View {
    let lijst: Lijst
    @Environment(NavigationContext.self) private var navigationContext
    @State private var isWoordEditorPresented = false
    @Binding var isLijstEditorPresented: Bool
    @Binding var isVoortgangSheetPresented: Bool

    var body: some View {
        @Bindable var navigationContext = navigationContext
        List(selection: $navigationContext.selectedWoord) {
            ForEach(lijst.woorden) { woord in
                NavigationLink(woord.naam, value: woord)
            }
            .onDelete(perform: verwijderWoorden)
        }
        .sheet(isPresented: $isWoordEditorPresented) {
            WoordEditor(woord: nil)
        }
        .sheet(isPresented: $isLijstEditorPresented) {
            LijstEditor(lijst: lijst)
        }
        .sheet(isPresented: $isVoortgangSheetPresented) {
            LijstVoortgangView(lijst: lijst)
        }
        .overlay {
            if lijst.woorden.isEmpty {
                ContentUnavailableView {
                    Label("Geen Woorden in deze lijst", systemImage: "pawprint")
                } description: {
                    AddWoordButton(isActive: $isWoordEditorPresented)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                AddWoordButton(isActive: $isWoordEditorPresented)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                BewerkLijstButton(isActive: $isLijstEditorPresented)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                StatistiekenButton(isActive: $isVoortgangSheetPresented)
            }
        }
        .padding()
        .navigationTitle(lijst.naam)
        
        Text("Niveau: \(lijst.niveau?.rawValue ?? "Onbekend")")
            .font(.subheadline)
    }

    private func verwijderWoorden(at indexSet: IndexSet) {
        for index in indexSet {
            let woordToDelete = lijst.woorden[index]
            if navigationContext.selectedWoord?.persistentModelID == woordToDelete.persistentModelID {
                navigationContext.selectedWoord = nil
            }
            lijst.woorden.remove(at: index)
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

private struct BewerkLijstButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Bewerk lijst", systemImage: "pencil")
                .help("Bewerk de huidige lijst")
        }
    }
}

private struct StatistiekenButton: View {
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            Label("Voortgang", systemImage: "chart.bar")
                .help("Bekijk de voortgang van de lijst")
        }
    }
}

private struct LijstVoortgangView: View {
    let lijst: Lijst
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Voortgang van de lijst \(lijst.naam)")
                .font(.title)
                .padding()
            Text("Aantal woorden: \(lijst.woorden.count)")
                .font(.headline)
            // Voeg hier meer statistieken toe, zoals 'geleerde woorden' als die functie bestaat
            Spacer()
            Button("Sluiten") {
                dismiss() // Dit sluit de sheet
            }
            .padding()
        }
        .padding()
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
