import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Lijst.lastUsed, order: .reverse) private var allLijsten: [Lijst]
    
    
    var recentLijsten: [Lijst] {
        Array(allLijsten.prefix(2))  // Limit to the 2 most recent lists
    }
    
    var favorieteLijsten: [Lijst] {
        allLijsten.filter { $0.isFavoriet }
    }
    
    var body: some View {
        NavigationStack {
            VStack() {

                ScrollView {
                    Image("homemonster")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .frame(height: 300)  // Fixed height for the image
                        .frame(maxWidth: .infinity)  // Fill the width of the screen
                        .clipped()

                    LazyVStack(spacing: 20) {
                        // Welcome Text
                        Text("Welkom bij FlitsMonster")
                            .font(.title)
                            .bold()
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        // Description Text
                        Text("Oefen met woordenlijsten om je vaardigheden te verbeteren!")
                            .padding(.bottom, 10)  // Adjust spacing after text
                        // Recent Lists Section
                        Section(header: Text("Meest Recent")
                            .font(.title2)
                            .bold()) {
                            if recentLijsten.isEmpty {
                                Text("Er zijn geen recent gebruikte lijsten.")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(recentLijsten) { lijst in
                                    NavigationLink(destination: FlitsScherm(lijst: lijst)) {
                                        LijstElement(lijst: lijst)
                                    }
                                }
                            }
                        }
                        
                        // Favorite Lists Section
                        Section(header: Text("Favorieten")
                            .font(.title2)
                            .bold()) {
                            if favorieteLijsten.isEmpty {
                                Text("Je kunt lijsten als favoriet markeren door op het hartje te klikken. Je vindt alle lijsten in het lijstmenu.")
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(favorieteLijsten) { lijst in
                                    NavigationLink(destination: FlitsScherm(lijst: lijst)) {
                                        LijstElement(lijst: lijst)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)  // Add padding to the scroll content
                }
            }

        }
    }
}

#Preview {
    ModelContainerPreview(ModelContainer.sample) {
        NavigationStack {
            HomeView()
        }
        .environment(NavigationContext())
    }
}
