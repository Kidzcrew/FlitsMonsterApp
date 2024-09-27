//
//  ContentView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationContext = NavigationContext()

    var body: some View {
        ThreeColumnContentView()
            .environment(navigationContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(try! ModelContainer.sample())
}
