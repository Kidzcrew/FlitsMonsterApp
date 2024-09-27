//
//  WoordDetailView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import SwiftUI
import SwiftData

struct WoordDetailView: View {
    var woord: Woord?
    @State private var isEditing = false
    @State private var isDeleting = false
    @Environment(\.modelContext) private var modelContext
    @Environment(NavigationContext.self) private var navigationContext

    var body: some View {
        if let woord {
            WoordDetailContentView(woord: woord)
                .navigationTitle("\(woord.naam)")
                .toolbar {
                    Button { isEditing = true } label: {
                        Label("Edit \(woord.naam)", systemImage: "pencil")
                            .help("Bewerk woord")
                    }
                    
                    Button { isDeleting = true } label: {
                        Label("Verwijder \(woord.naam)", systemImage: "trash")
                            .help("Verwijder het woord")
                    }
                }
                .sheet(isPresented: $isEditing) {
                    WoordEditor(woord: woord)
                }
                .alert("Delete \(woord.naam)?", isPresented: $isDeleting) {
                    Button("Yep, weg ermee \(woord.naam)", role: .destructive) {
                        delete(woord)
                    }
                }
        } else {
            ContentUnavailableView("Kies een woord", systemImage: "pawprint")
        }
    }
    
    private func delete(_ woord: Woord) {
        navigationContext.selectedWoord = nil
        modelContext.delete(woord)
    }
}

private struct WoordDetailContentView: View {
    let woord: Woord

    var body: some View {
        VStack {
            #if os(macOS)
            Text(woord.naam)
                .font(.title)
                .padding()
            #else
            EmptyView()
            #endif
            
            List {
                HStack {
                    Text("Lijst")
                    Spacer()
                    Text("\(woord.lijst?.naam ?? "")")
                }
                HStack {
                    Text("Soort")
                    Spacer()
                    Text("\(woord.soort.rawValue)")
                }
            }
        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        WoordDetailView(woord: .kip)
            .environment(NavigationContext())
    }
}
