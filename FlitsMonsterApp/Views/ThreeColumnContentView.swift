/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that shows a list of woordenlijsten.
*/

import SwiftUI
import SwiftData

struct ThreeColumnContentView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        @Bindable var navigationContext = navigationContext
        NavigationSplitView(columnVisibility: $navigationContext.columnVisibility) {
            LijstenView()
                .navigationTitle(navigationContext.sidebarTitle)
        } content: {
            WoordenLijstView(lijst: navigationContext.selectedLijst)
                .navigationTitle(navigationContext.contentListTitle)
        } detail: {
            NavigationStack {
                WoordDetailView(woord: navigationContext.selectedWoord)
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        ThreeColumnContentView()
            .environment(NavigationContext())
    }
}
