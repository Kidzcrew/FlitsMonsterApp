import SwiftUI
import SwiftData

struct WoordenLijstView: View {
    let lijst: Lijst

    var body: some View {
        WoordLijst(lijst: lijst)
    }
}

private struct WoordLijst: View {
    @Bindable var lijst: Lijst
    @Environment(NavigationContext.self) private var navigationContext
    @Environment(\.dismiss) private var dismiss
    @State private var isWoordEditorPresented = false
    @State private var isLijstEditorPresented = false
    @State private var isVoortgangSheetPresented = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(lijst.icoon)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 350)
                    .clipped()
                    .clipShape(RoundedCorners(radius: 25, corners: [.bottomLeft, .bottomRight]))
                    .ignoresSafeArea(edges: .top)
                
                VStack(alignment: .leading) {
                    Spacer(minLength: 230)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("niveau:")
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(6)
                            
                            Text(lijst.niveau?.rawValue ?? "E3")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(RoundedRectangle(cornerRadius: 3).fill(Color.purple))
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                BewerkLijstButton(isActive: $isLijstEditorPresented)
                                StatistiekenButton(isActive: $isVoortgangSheetPresented)
                                AddWoordButton(isActive: $isWoordEditorPresented)
                            }
                            .padding(10)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray5))
                        )
                        
                        Text(lijst.naam)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(lijst.beschrijving)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding([.leading, .trailing])
                    
                    // Adjusted Woordenlijst using id
                    List {
                        Text("Woorden:")
                            .font(.headline)
                        
                        // Use id: \.id to ensure words are unique
                        ForEach(lijst.woorden, id: \.id) { woord in
                            NavigationLink(destination: WoordDetailView(woorden: $lijst.woorden, woord: woord)) {
                                Text(woord.naam)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .onAppear {
                        print("Lijst \(lijst.naam) has appeared.")
                    }
                    .onDisappear {
                        // Perform cleanup actions when navigating away
                        print("Lijst \(lijst.naam) has disappeared.")
                        
                    }
                }
            }
            .sheet(isPresented: $isWoordEditorPresented) {
                WoordEditor(woord: nil, lijst: lijst, woorden: $lijst.woorden)
            }
            .sheet(isPresented: $isLijstEditorPresented) {
                LijstEditor(lijst: lijst)
            }
            .sheet(isPresented: $isVoortgangSheetPresented) {
                LijstVoortgangView(lijst: lijst)
            }
            .navigationTitle("")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    // Toolbar buttons
    private struct AddWoordButton: View {
        @Binding var isActive: Bool
        
        var body: some View {
            Button {
                isActive = true
            } label: {
                Label("", systemImage: "plus")
                    .help("Voeg woord toe")
            }
        }
    }
    
    private struct BewerkLijstButton: View {
        @Binding var isActive: Bool
        
        var body: some View {
            Button {
                isActive = true
            } label: {
                Image(systemName: "pencil")
            }
        }
    }
    
    private struct StatistiekenButton: View {
        @Binding var isActive: Bool
        
        var body: some View {
            Button {
                isActive = true
            } label: {
                Image(systemName: "chart.bar")
            }
        }
    }
    
    private struct LijstVoortgangView: View {
        let lijst: Lijst
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            VStack {
                Text("Voortgang van de lijst \(lijst.naam)")
                    .font(.title)
                    .padding()
                
                Text("Aantal resterende woorden: \(lijst.woorden.count)")
                    .font(.headline)
                
                Spacer()
                
                Button("Sluiten") {
                    dismiss()
                }
                .padding()
            }
            .padding()
        }
    }
    
    #Preview("WoordenLijstView") {
        ModelContainerPreview(ModelContainer.sample) {
            NavigationStack {
                WoordenLijstView(lijst: Lijst.lijstE3)
                    .environment(NavigationContext())
            }
        }
    }
    
    #Preview("geen lijst geselecteerd") {
        ModelContainerPreview(ModelContainer.sample) {
            WoordenLijstView(lijst: Lijst.lijstE3)
        }
    }
}
