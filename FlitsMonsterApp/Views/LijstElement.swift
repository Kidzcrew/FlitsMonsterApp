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

                HStack(spacing: 0) {
                    Image(lijst.icoon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10)))

                    VStack(alignment: .leading, spacing: 5) {
                        Text(lijst.naam)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                        
                        Text(lijst.beschrijving)
                            .foregroundStyle(.white)
                            .font(.footnote)
                            .lineLimit(2)
                            .minimumScaleFactor(0.6)
                        Text("\(lijst.woorden.count) Woorden")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                        Text("AVI \(lijst.niveau?.rawValue ?? "Onbekend")")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .bold()
                    }
                    .padding(.leading, 10)

                    Spacer()

                    NavigationLink(destination: FlitsScherm(lijst: lijst)) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(Color(hex: lijst.kleurPrimair))
                    }
                    .padding(.trailing, 10)
                }
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

            ZStack {
                UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 10, bottomTrailing: 10))
                    .frame(height: isExpanded ? 80.0 : 40.0)
                    .foregroundStyle(Color.white)

                VStack {
                    if isExpanded {
                        HStack {
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
                        }

                        Divider()
                            .frame(height: 1)
                            .background(Color.gray)
                            .opacity(0.3)

                        ZStack {
                            HStack {

                                NavigationLink(destination: WoordenLijstView(lijst: lijst)) {
                                    Image(systemName: "eye.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(.blue)
                                    Text("lijstdetails")
                                        .foregroundStyle(.blue)
                                        .font(.subheadline)
                                        
                                }
                                Spacer()
                                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                                Text("\(lijst.voortgang)x")
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }) {
                                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                    } else {
                        ZStack {
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
                                Spacer()
                            }
                            HStack {
                            Spacer()
                                Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                                Text("\(lijst.voortgang)x")
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                            }
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
            icoon: "monster1",
            taal: .nl
        )
    )
}
