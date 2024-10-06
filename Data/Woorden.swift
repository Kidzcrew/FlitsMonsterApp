//
//  Woorden.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 25/09/2024.
//

import Foundation

extension Woord {
    static let lijstM3 = Lijst(naam: "Lijst M3", beschrijving: "Voor groep M3", niveau: .M3)
    static let lijstM4 = Lijst(naam: "Lijst M4", beschrijving: "Voor groep M4", niveau: .M4)
    static let lijstM5 = Lijst(naam: "Lijst M5", beschrijving: "Voor groep M5", niveau: .M5)

    static let aap = Woord(naam: "aap", soort: .hoorman, lijsten: [lijstM3])
    static let noot = Woord(naam: "noot", soort: .letterzetter, lijsten: [lijstM3, lijstM4])
    static let mies = Woord(naam: "mies", soort: .letterdief, lijsten: [lijstM3])
    static let manden = Woord(naam: "manden", soort: .hoorman, lijsten: [lijstM4])
    static let ballen = Woord(naam: "ballen", soort: .letterzetter, lijsten: [lijstM4])
    static let balen = Woord(naam: "balen", soort: .letterdief, lijsten: [lijstM5])
    static let fietsje = Woord(naam: "fietsje", soort: .hoorman, lijsten: [lijstM5])
    static let gebakken = Woord(naam: "gebakken", soort: .letterzetter, lijsten: [lijstM5])
    static let gapen = Woord(naam: "gapen", soort: .letterdief, lijsten: [lijstM3, lijstM5])
    static let werken = Woord(naam: "werken", soort: .hoorman, lijsten: [lijstM4])
    static let wekken = Woord(naam: "wekken", soort: .letterzetter, lijsten: [lijstM4])
    static let weken = Woord(naam: "weken", soort: .letterdief, lijsten: [lijstM5])
    static let kip = Woord(naam: "kip", soort: .hoorman, lijsten: [lijstM3])
}
