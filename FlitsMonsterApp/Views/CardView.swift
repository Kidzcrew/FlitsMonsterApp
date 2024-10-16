import SwiftUI
import SwiftData

struct CardView: View, Identifiable {
    let id = UUID()
    let woord: Woord
  //  let textColor: Color  // Dynamically control the text color based on swipe direction

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#F1F1F1"))  // Background color for the card
                .frame(height: 250)
                .shadow(radius: 5)

            // Text overlay for the word with a dynamic color
            Text(woord.naam)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .bold()
                .kerning(5.0)
               // .foregroundColor(textColor)  // Dynamically change the text color
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 120.0)
    }
}

#Preview {
    // Example list and word for preview purposes
    let lijst = Lijst.lijstM4
    let woord = Woord(naam: "aap", soort: .hoorman, lijsten: [lijst])  // Word belonging to lijstM4

    // Example: blue text color for preview
    return CardView(woord: woord)
}
