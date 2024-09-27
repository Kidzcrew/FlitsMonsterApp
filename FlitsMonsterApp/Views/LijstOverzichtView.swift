/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that displays a list of woorden lijsten 
*/

import SwiftUI
import SwiftData

struct LijstenView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Lijst.naam) private var woordLijsten: [Lijst]
    @State private var isReloadPresented = false

    var body: some View {
        @Bindable var navigationContext = navigationContext
        List(selection: $navigationContext.selectedLijst) {
            #if os(macOS)
            Section(navigationContext.sidebarTitle) {
                ListCategories(woordLijsten: woordLijsten)
            }
            #else
            ListCategories(woordLijsten: woordLijsten)
            #endif
        }
        .alert("Reload Sample Data?", isPresented: $isReloadPresented) {
            Button("Yes, reload sample data", role: .destructive) {
                reloadSampleData()
            }
        } message: {
            Text("Reloading the sample data deletes all changes to the current data.")
        }
        .toolbar {
            Button {
                isReloadPresented = true
            } label: {
                Label("", systemImage: "arrow.clockwise")
                    .help("Reload sample data")
            }
        }
        .task {
            if woordLijsten.isEmpty {
                print("woordenlijst is leeg - sample gebruikt")
                Lijst.insertSampleData(modelContext: modelContext)
            }
        }
    }
    
    @MainActor
    private func reloadSampleData() {
        navigationContext.selectedWoord = nil
        navigationContext.selectedLijst = nil
        Lijst.reloadSampleData(modelContext: modelContext)
    }
}

private struct ListCategories: View {
    var woordLijsten: [Lijst]
    
    var body: some View {
        ForEach(woordLijsten) { lijst in
            NavigationLink(lijst.naam, value: lijst)
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

#Preview("WoordLijsten") {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            List {
                ListCategories(woordLijsten: [.lijstE3, .lijstE4])
            }
        }
        .environment(NavigationContext())
    }
}
