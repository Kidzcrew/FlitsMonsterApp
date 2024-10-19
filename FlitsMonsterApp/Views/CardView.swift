import SwiftUI
import SwiftData

struct CardView: View, Identifiable {
    let id = UUID()
    let woord: Woord

    @AppStorage("selectedFont") private var selectedFont: String = "San Francisco"  // Automatically update when selectedFont changes

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F1F1F1"))  // Background color for the card
                .frame(height: 250)
                .shadow(radius: 5)

            // Text overlay for the word with a dynamic font
            Text(woord.naam)
                .font(getFont(for: selectedFont, size: 35))  // Dynamically apply the font based on AppStorage
                //.fontWeight(.bold)
                .multilineTextAlignment(.center)
                .bold()
                .kerning(5.0)
                .lineLimit(1)  // Restrict to a single line
                .minimumScaleFactor(0.5)  // Allows the text to scale down to 50% of the original size if needed
                .foregroundColor(.black)  // Ensuring text remains visible
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 120.0)
    }
}

#Preview {
    // Example list and word for preview purposes
    let lijst = Lijst.lijstM4
    let woord = Woord(naam: "aap", soort: .hoorman, lijsten: [lijst])  // Word belonging to lijstM4

    return CardView(woord: woord)
}

// Aangepaste fonts aanroepen (adjusted custom font function)
func getFont(for fontName: String, size: CGFloat) -> Font {
    switch fontName {
    case "Dyslexie":
        print("Dyslexie returned")
        return Font.custom("OpenDyslexic-Regular", size: size * 1.1)  // Slightly larger for Dyslexie font
    case "Krijtbord":
        print("ChalkboardSE returned")
        return Font.custom("ChalkboardSE-Regular", size: size * 1.3)  // Slightly smaller for Chalkboard
    case "School":
        print("School returned")
        return Font.custom("SchoolKX_new", size: size * 1.3)  // Slightly larger for School font
    default:
        print("default SF font returned")
        return Font.system(size: size) // Default to San Francisco, no adjustment
    }
}
