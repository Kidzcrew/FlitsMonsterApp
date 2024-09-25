//
//  Item.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
