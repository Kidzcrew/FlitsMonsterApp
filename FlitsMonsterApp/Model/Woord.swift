//
//  Woord.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

@Model
final class Woord: Identifiable {
    var id = UUID()
    var naam: String
    var soort: Soort
    var lijsten: [Lijst]
    
    init(naam: String, soort: Soort, lijsten: [Lijst]) {
        self.naam = naam
        self.soort = soort
        self.lijsten = lijsten
    }
}

extension Woord {
    enum Soort: String, CaseIterable, Codable {
        case hoorman = "Hoorman"
        case letterzetter = "Letterzetter"
        case letterdief = "Letterdief"
    }
}
