import SwiftUI
import SwiftData

struct SessionSummaryView: View {
    let knownCount: Int
    let morePracticeWords: [Woord]
    let restartSession: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Wat goed!")
                .font(.title)
                .bold()

            Text("Je wist deze ronde wel \(knownCount) woorden!")
                .font(.headline)

            if !morePracticeWords.isEmpty {
                Text("Lees deze woorden nog eens door:")
                    .font(.subheadline)
                    .bold()
                ForEach(morePracticeWords.prefix(5), id: \.id) { woord in
                    Text(woord.naam)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }

            Button("Nog een keer!") {
                restartSession()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 10)

            Button("Ga terug") {
                // Use dismiss for modal or presentation in NavigationStack
                dismiss()
            }
            .buttonStyle(.bordered)
            .padding(.top, 5)
        }
        .padding()
    }
}

#Preview {
    SessionSummaryView(knownCount: 12, morePracticeWords: [.init(naam: "TestWoord", soort: .hoorman, lijsten: [])], restartSession: {})
}
