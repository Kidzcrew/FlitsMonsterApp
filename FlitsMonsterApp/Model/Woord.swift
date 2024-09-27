//
//  Woord.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

@Model
final class Woord {
    var naam: String
    var soort: Soort
    var lijst: Lijst?
    
    init(naam: String, soort: Soort) {
        self.naam = naam
        self.soort = soort
    }
}

extension Woord {
    enum Soort: String, CaseIterable, Codable {
        case hoorman = "Hoorman"
        case letterzetter = "Letterzetter"
        case letterdief = "Letterdief"
    }
}
