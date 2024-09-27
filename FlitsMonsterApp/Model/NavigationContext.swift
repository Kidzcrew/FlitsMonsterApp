//
//  NavigationContext.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//


import SwiftUI

@Observable
class NavigationContext {
    var selectedLijst: Lijst?
    var selectedWoord: Woord?
    var columnVisibility: NavigationSplitViewVisibility
    
    var sidebarTitle = "Lijsten"
    
    var contentListTitle: String {
        selectedLijst?.naam ?? ""
    }
    
    init(selectedLijst: Lijst? = nil,
         selectedWoord: Woord? = nil,
         columnVisibility: NavigationSplitViewVisibility = .automatic) {
        self.selectedLijst = selectedLijst
        self.selectedWoord = selectedWoord
        self.columnVisibility = columnVisibility
    }
}
