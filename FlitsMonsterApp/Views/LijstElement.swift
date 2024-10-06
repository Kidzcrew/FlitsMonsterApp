import SwiftUI
import SwiftData

struct LijstElement: View {
    @State private var isExpanded: Bool = false
    @Bindable var lijst: Lijst // Ontvang het volledige Lijst-object

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, topTrailing: 10))
                    .frame(height: 110.0)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: lijst.kleurPrimair), Color(hex: lijst.kleurSecundair)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                HStack {
                    Image(lijst.icoon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                        .padding(.horizontal, 10)

                    VStack(alignment: .leading) {
                        Text(lijst.naam)
                            .foregroundStyle(.white)
                            .font(.footnote)
                        Text(lijst.beschrijving)
                            .foregroundStyle(.white)
                            .bold()
                            .font(.subheadline)
                    }
                    Spacer()

                    // Chevron voor WoordenLijstView
                    NavigationLink(destination: WoordenLijstView(lijst: lijst)) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 10)
                }
                .padding([.leading, .trailing], 10)

                // Het hartje linksboven
                Button(action: {
                    // Toggle de favorietenstatus en sla de wijziging op
                    lijst.isFavoriet.toggle()
                    saveFavorietStatus()
                }) {
                    Image(systemName: lijst.isFavoriet ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(lijst.isFavoriet ? .red : .white) // Rood als het een favoriet is, anders wit
                        .padding(8)
                }
                .background(Color.white.opacity(0.6))
                .cornerRadius(20)
                .padding(.leading, 10)
                .padding(.top, 10)
            }
            .frame(maxWidth: 400)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.blue)
                    .frame(height: 3)
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.green)
                    .frame(width: CGFloat(lijst.voortgang) * 4, height: 3)
            }
            .frame(maxWidth: 400)
            .padding(.vertical, -4)

            ZStack {
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 10, bottomTrailing: 10))
                    .frame(height: isExpanded ? 100.0 : 40.0)
                    .foregroundStyle(Color.white)

                VStack {
                    if isExpanded {
                        HStack {
                            Text("Niveau: \(lijst.niveau?.rawValue ?? "Onbekend")")
                                .foregroundStyle(.purple)
                                .font(.subheadline)
                                .bold()
                            Text("Woorden:")
                                .foregroundStyle(.gray)
                                .font(.footnote)
                                .bold()

                            if lijst.woorden.count < 10 {
                                Text(lijst.woorden.map { $0.naam }.joined(separator: ", "))
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                            } else {
                                let eersteVijf = lijst.woorden.prefix(5).map { $0.naam }.joined(separator: ", ")
                                let laatsteVijf = lijst.woorden.suffix(5).map { $0.naam }.joined(separator: ", ")
                                Text("\(eersteVijf) ... \(laatsteVijf)")
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                            }

                            Spacer()
                            Text("\(lijst.woorden.count) Woorden")
                                .foregroundStyle(.purple)
                                .font(.subheadline)
                                .bold()
                        }

                        Divider()
                            .frame(height: 1)
                            .background(Color.gray)
                            .opacity(0.5)

                        HStack {
                            Button(action: {
                                print("Statistieken aangeraakt")
                            }) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.blue)
                            }
                            Spacer()

                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Text("Geoefend: \(lijst.voortgang) keer")
                                .foregroundStyle(.blue)
                                .font(.subheadline)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                Image(systemName: "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.trailing, 80)

                            Text("Geoefend: \(lijst.voortgang) keer")
                                .foregroundStyle(.blue)
                                .font(.subheadline)
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
            .frame(maxWidth: 400)
            .padding(.bottom, isExpanded ? 8 : 0)
        }
        .padding(.horizontal, 10)
    }

    // Functie om de favorietenstatus op te slaan
    private func saveFavorietStatus() {
        do {
            try lijst.modelContext?.save()
        } catch {
            print("Fout bij het opslaan van de favorietenstatus: \(error)")
        }
    }
}

#Preview {
    LijstElement(
        lijst: Lijst(
            naam: "Voorbeeldlijst",
            beschrijving: "Voorbeeldbeschrijving",
            niveau: .M3,
            kleurPrimair: "#FF512F",
            kleurSecundair: "#1BFFFF",
            icoon: "monster1"
        )
    )
}
