//
//  Lijst.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

@Model
final class Lijst {
    @Attribute(.unique) var naam: String
    @Attribute var beschrijving: String?
    @Attribute var niveau: String?
    // `.cascade` tells SwiftData to delete all words contained in the category when deleting it.
    @Relationship(deleteRule: .cascade, inverse: \Woord.lijst)
    var woorden = [Woord]()
    
    init(naam: String) {
        self.naam = naam
        self.beschrijving = nil
        self.niveau = nil
    }
}
