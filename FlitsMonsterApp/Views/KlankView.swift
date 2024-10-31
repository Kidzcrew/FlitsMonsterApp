//
//  KlankView.swift
//  FlitsMonsterApp
//
//  Created by Jeroen de Bruin on 30/10/2024.
//

import SwiftUI
import SwiftData

// Verplaats combinaties naar constante variabelen buiten de functie
let vierklankCombinaties = ["eeuw", "ieuw"]
let drieklankCombinaties = ["oei", "aai", "ooi"]
let tweeklankCombinaties = ["uw","oe", "aa", "ui", "ie", "ei", "ou", "au", "eu", "ij", "ee", "oo", "uu"]

func splitIntoKlanken(word: String) -> [String] {
    var result = [String]()
    var index = word.startIndex
    
    while index < word.endIndex {
        var foundKlank = false
        
        // Check voor vierklanken
        if index < word.index(word.endIndex, offsetBy: -3) { // Zorg dat er nog 4 karakters zijn
            let fourCharSubstring = String(word[index...word.index(index, offsetBy: 3)])
            if vierklankCombinaties.contains(fourCharSubstring) {
                result.append(fourCharSubstring)
                index = word.index(index, offsetBy: 4)
                foundKlank = true
            }
        }
        
        // Check voor drieklanken als geen vierklank gevonden
        if !foundKlank && index < word.index(word.endIndex, offsetBy: -2) {
            let threeCharSubstring = String(word[index...word.index(index, offsetBy: 2)])
            if drieklankCombinaties.contains(threeCharSubstring) {
                result.append(threeCharSubstring)
                index = word.index(index, offsetBy: 3)
                foundKlank = true
            }
        }
        
        // Check voor tweeklanken als geen drieklank gevonden
        if !foundKlank && index < word.index(before: word.endIndex) {
            let twoCharSubstring = String(word[index...word.index(after: index)])
            if tweeklankCombinaties.contains(twoCharSubstring) {
                result.append(twoCharSubstring)
                index = word.index(index, offsetBy: 2)
                foundKlank = true
            }
        }
        
        // Voeg één letter toe als geen klank gevonden
        if !foundKlank {
            result.append(String(word[index]))
            index = word.index(after: index)
        }
    }
    
    return result
}

// View voor een enkel klank-hokje
struct KlankView: View {
    let klank: String
    
    var body: some View {
        Text(klank)
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(width: boxWidth(), height: 50) // Dynamische breedte
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
           // .padding(1)
    }
    
    // Bepaal de breedte op basis van de lengte van de klank
    private func boxWidth() -> CGFloat {
        switch klank.count {
        case 4: return 100 // Vierklank
        case 3: return 75  // Drieklank
        case 2: return 60  // Tweeklank
        default: return 40 // Enkel klank
        }
    }
}

// Hoofdview om het woord als klanken weer te geven
struct KlankWoordView: View {
    let woord: String
    
    var body: some View {
        HStack {
            ForEach(splitIntoKlanken(word: woord), id: \.self) { klank in
                KlankView(klank: klank)
            }
        }
        .padding(5)
        .background(Color(white: 0.9))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}

// Voorbeeld preview
struct KlankWoordView_Previews: PreviewProvider {
    static var previews: some View {
        KlankWoordView(woord: "leeuwen")
            .padding()
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
}
