//
//  NavigationContext.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//


import SwiftUI

@Observable
class NavigationContext {
    var selectedLijstNaam: String?
    var selectedWoord: Woord?
    var columnVisibility: NavigationSplitViewVisibility
    
    var sidebarTitle = "Lijsten"
    
    var contentListTitle: String {
        if let selectedLijstNaam {
            selectedLijstNaam
        } else {
            ""
        }
    }
    
    init(selectedLijstNaam: String? = nil,
         selectedWoord: Woord? = nil,
         columnVisibility: NavigationSplitViewVisibility = .automatic) {
        self.selectedLijstNaam = selectedLijstNaam
        self.selectedWoord = selectedWoord
        self.columnVisibility = columnVisibility
    }
}
