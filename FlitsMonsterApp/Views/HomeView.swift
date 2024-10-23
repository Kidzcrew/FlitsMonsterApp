import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Lijst.lastUsed, order: .reverse) private var allLijsten: [Lijst]
    
    @State private var isReloadPresented = false
    
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
                                    LijstElement(lijst: lijst)
                                        .onTapGesture {
                                            navigationContext.selectedLijst = lijst
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
                                    LijstElement(lijst: lijst)
                                        .onTapGesture {
                                            navigationContext.selectedLijst = lijst
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)  // Add padding to the scroll content
                }
            }
            .toolbar {
                Button {
                    isReloadPresented = true
                } label: {
                    Label("", systemImage: "arrow.clockwise")
                        .help("Reload sample data")
                }
            }
            .alert("Sample Data Herladen?", isPresented: $isReloadPresented) {
                Button("Ja, herlaad sample data", role: .destructive) {
                    Lijst.reloadSampleData(modelContext: modelContext)
                }
            } message: {
                Text("Herladen van de sample data verwijdert alle bestaande wijzigingen.")
            }
            .task {
                if allLijsten.isEmpty {
                    Lijst.insertSampleData(modelContext: modelContext)
                }
            }
            .navigationDestination(for: Lijst.self) { lijst in
                FlitsScherm(lijst: lijst)
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
