// CardView.swift

import SwiftUI
import SwiftData

struct CardView: View, Identifiable {
    let id = UUID()
    let woord: Woord

    @AppStorage("selectedFont") private var selectedFont: String = "San Francisco"
    @AppStorage("enableKlankView") private var enableKlankView = true // Nieuwe opslag voor KlankView

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F1F1F1"))
                .frame(height: 250)
                .shadow(radius: 5)

            if enableKlankView {
                // Toon de KlankWoordView
                KlankWoordView(woord: woord.naam)
            } else {
                // Toon het woord als gewone tekst met automatische schaalverkleining
                Text(woord.naam)
                    .font(getFont(for: selectedFont, size: 35))
                    .multilineTextAlignment(.center)
                    .bold()
                    .kerning(5.0)
                    .lineLimit(1)                // Houd tekst op één regel
                    .minimumScaleFactor(0.3)      // Schaal automatisch terug als de tekst te groot is
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)   // Zorgt ervoor dat het woord de beschikbare breedte gebruikt
            }
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 120.0)
    }
}

#Preview {
    let lijst = Lijst.lijstM4
    let woord = Woord(naam: "aap", soort: .hoorman, lijsten: [lijst])

    return CardView(woord: woord)
}

func getFont(for fontName: String, size: CGFloat) -> Font {
    switch fontName {
    case "Dyslexie":
        return Font.custom("OpenDyslexic-Regular", size: size * 1.1)
    case "Krijtbord":
        return Font.custom("ChalkboardSE-Regular", size: size * 1.3)
    case "School":
        return Font.custom("SchoolKX_new", size: size * 1.3)
    default:
        return Font.system(size: size)
    }
}
