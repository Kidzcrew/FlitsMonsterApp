/* import SwiftUI

struct LijstElement: View {
    @State private var isExpanded: Bool = false
    var lijst: Lijst // Ontvang het volledige Lijst-object

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
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
                        .padding(.horizontal, 10)
                        .scaledToFit()
                        .frame(width: 100)

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

                    // Correcte aanroep naar WoordenLijstView met een Lijst-object
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
            }
            .frame(maxWidth: 400)

            ProgressView(value: Double(lijst.voortgang) / 100.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .frame(maxWidth: 400, maxHeight: 3)
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
                            Text(lijst.woorden.map { $0.naam }.joined(separator: ", "))
                                .foregroundStyle(.gray)
                                .font(.footnote)
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
                                print("Favoriet aangeraakt")
                            }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                                    .opacity(0.2)
                            }
                            Button(action: {
                                print("Bewerken aangeraakt")
                            }) {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.blue)
                            }
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
                            Text("Geoefend: 17x")
                                .foregroundStyle(.blue)
                                .font(.subheadline)
                        }
                    } else {
                        HStack {
                            Button(action: {
                                print("Favoriet aangeraakt")
                            }) {
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.gray)
                                    .opacity(0.2)
                            }
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

                            Text("Geoefend: 17x")
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
}

#Preview {
    LijstElement(
        lijst: Lijst(
            naam: "Voorbeeldlijst",
            beschrijving: "Voorbeeldbeschrijving",
            niveau: .M3,
            kleurPrimair: "#FF512F",
            kleurSecundair: "#1BFFFF",
            icoon: "star"
        )
    )
}
*/
